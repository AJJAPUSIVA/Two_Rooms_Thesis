function Results = ofdmModulation_func(SNRdB,chanPow,upsampleRate)
%% Control parameters ---------------------------------------------------------------
    ctrl_ifDisplayResults         = 1;
    ctrl_ifplotConstellation      = 1;
%------------------------------------------------------------------------------------    
%% Independent Parameters -----------------------------------------------------------
    % related to simulations
    numOfBlocks     = 10;        % number of blocks

    % OFDM parameters
    modulation      = 'QPSK';   % modulation scheme 'QPSK','16QAM','64QAM
    fftBlockSize    = 128;      % number of subcarriers (fft/ifft size)
    guardInterval   = 1/4;      % ratio of guard interval 
    
    % related to channel
    channelTapsNum  = 2;        % number of channel taps > 1
    channelEbN0dB   = 8;        % AWGN channel EbN0 for each Rx chain

%------------------------------------------------------------------------------------    
%% Dependent variables --------------------------------------------------------------
    % check parameter
        
    % only odd subcarriers are modulation (including DC)
        dataInd  = (2:2:fftBlockSize/2)';
        dataIndH = (fftBlockSize/2+2):2:fftBlockSize;
    % find number of data subcarriers
        numOfDataSubCarriers = length(dataInd);
        
    % find number of bits per symbol
        if     strcmpi(modulation,'BPSK')
            numOfBitsPerSymbol = 1;         % number of bits per BPSK  symbol
            modulationPower    = 1;         % it is comming from communications
        elseif strcmpi(modulation,'QPSK')
            numOfBitsPerSymbol = 2;         % number of bits per QPSK  symbol
            modulationPower    = 2;         % it is comming from communications
        elseif strcmpi(modulation,'16QAM')
            numOfBitsPerSymbol = 4;         % number of bits per 16QAM symbol
            modulationPower    = 10;        % it is comming from communications
        elseif strcmpi(modulation,'64QAM')
            numOfBitsPerSymbol = 6;         % number of bits per 64QAM symbol
            modulationPower    = 42;        % it is comming from communications
        elseif strcmpi(modulation,'256QAM')
            numOfBitsPerSymbol = 8;         % number of bits per 64QAM symbol
            modulationPower    = sum(abs(qammod(0:251,256)).^2)/256;
        elseif strcmpi(modulation,'1024QAM')
            numOfBitsPerSymbol = 10;         % number of bits per 64QAM symbol
            modulationPower    = sum(abs(qammod(0:1023,1024)).^2)/1024;
        else
            error('This modulation is not supported.')
        end   
    
    % find chanel SNR (ref -> https://en.wikipedia.org/wiki/Eb/N0)
        channelSnrdB = SNRdB + ...
            10*log10(numOfDataSubCarriers./fftBlockSize);
   
    % find number of bits to be generated for each block
        numOfBitsPerBlock       = numOfDataSubCarriers*numOfBitsPerSymbol;  
        
    % find number of symbols in each block
        numOfSymbolsPerBlock    = numOfBitsPerBlock/numOfBitsPerSymbol;
    
    % find number of bits to be generated for all blocks
        numOfBitsTotal          = numOfBitsPerBlock*numOfBlocks;
    
    % find total number of symbols
        numOfSymbolsTotal       = numOfBitsTotal/numOfBitsPerSymbol;
    
    % find noise power
        noiseVar = 1*10^(-0.1*channelSnrdB);

%------------------------------------------------------------------------------------    
%% Data generation ------------------------------------------------------------------
    % generate bits
    bits = randi([0 1],numOfBitsTotal,1);    
%------------------------------------------------------------------------------------    
%% Transmitter ----------------------------------------------------------------------
    
    % bit to symbol conversion 
        % here we set the bits like b0   b1
        %                           b2   b3 
        %                           ...
        %                           bN-1 bN
        % and then convert the binary values to decimal
        temp          = ... % temporary variable
            reshape(bits,numOfSymbolsTotal,numOfBitsPerSymbol);
        serialSymbols = bi2de(temp);
        
    % serial to parallel conversion 
        parallelSymbols = reshape(serialSymbols,numOfSymbolsPerBlock,numOfBlocks);
    
    % bit to QAM symbol conversion         
        modSymbols = 1./sqrt(modulationPower)*...
            qammod(parallelSymbols,2^numOfBitsPerSymbol,'gray');   
        
    % building block ( % Hermitian symmetry)
        blocks             = zeros(fftBlockSize,numOfBlocks); 
        blocks(dataInd ,:) = modSymbols;
        blocks(dataIndH,:) = conj(modSymbols(end:-1:1,:));
        
        
    % IFFT operation 
    % Note: sqrt(2*fftBlockSize) normalizes to power to 1
        ifftSymbols = sqrt(2*fftBlockSize)*ifft(blocks);
    
    % add cyclic prefix
        txSignal   = [ifftSymbols(((1-guardInterval)*fftBlockSize+1):end,:);
                      ifftSymbols];
                  
    % add clipping signal (note 2 is multiplied to keep the signal power at
    % 1)
        txSignal = real(txSignal);
        txSignal(txSignal<0) = 0;
        txSignal = txSignal*2;
%------------------------------------------------------------------------------------    
%% channel --------------------------------------------------------------------------
    % upsampling
    chanPowNorm  = chanPow./norm(chanPow);
    upSymbols    = zeros(size(txSignal,1)*upsampleRate,size(txSignal,2));
    for b = 1 : numOfBlocks
        upSymbols(:,b)    = rectpulse(double(txSignal(:,b)),upsampleRate);
    end
    % path the information through channel
    rxUpSymbols = filter(chanPowNorm,1,upSymbols);
   
    % add noise
    noisyUpSymbols = awgn(rxUpSymbols,channelSnrdB-10*log10(upsampleRate),'measured');
   
    % filter noisy signal
    filteredSymbol = filter(1/upsampleRate*ones(upsampleRate,1),1,noisyUpSymbols);
    
    % downsample
    delay     = floor((upsampleRate-1)/1 + (length(chanPowNorm)-1)/2)-4;
    rxSignal  = filteredSymbol(delay : upsampleRate : end,:);
    
    h = max(chanPowNorm(1));
    H = ones(fftBlockSize,numOfBlocks).*h;        
%------------------------------------------------------------------------------------    
%% Receiver -------------------------------------------------------------------------
    % remove cyclic prefix
    ifftSymbolsEst = rxSignal((guardInterval*fftBlockSize+1):end,:);
    
    % taking FFT 
    modSymbolsEst  = 1/sqrt(fftBlockSize)*fft(ifftSymbolsEst);
    
    % MMSE detection for perfect channel state information
    modSymbolsDet  = modSymbolsEst(dataInd,:).*...
        conj(H(dataInd,:))./(abs(H(dataInd,:)).^2+noiseVar);
    
    % QAM demodulation 
        parallelSymbolsEst  = ...
            qamdemod(sqrt(1/2*modulationPower)*modSymbolsDet,...
                              2^numOfBitsPerSymbol,'gray');
    if ctrl_ifplotConstellation
        figure(10)
        clf
        plot(real(modSymbolsDet(:)),imag(modSymbolsDet(:)),'.')
        xlabel('real')
        ylabel('imaginary')
        title('OFDM constellations')
    end
%------------------------------------------------------------------------------------    
%% BER calaculation -----------------------------------------------------------------
    % system with perfect channel state information 
    [~,symErr] = symerr(parallelSymbolsEst,parallelSymbols);
    [~,bitErr] = biterr(parallelSymbolsEst,parallelSymbols,numOfBitsPerSymbol);
    
   
    % find BER of theory
    if numOfBitsPerSymbol == 1
        bitErrTheoryAWGN   = berawgn(channelEbN0dB,'psk',2^numOfBitsPerSymbol,'non-diff');
    else        
        bitErrTheoryAWGN   = berawgn(channelEbN0dB,'qam',2^numOfBitsPerSymbol);
    end
%------------------------------------------------------------------------------------    
%% Store results --------------------------------------------------------------------
    Results.SNR_dB                  = channelSnrdB;
    Results.symErr                  = symErr;
    Results.bitErr                  = bitErr;
    Results.bitErrTheoryAWGN        = bitErrTheoryAWGN;    
    if ctrl_ifDisplayResults
        fprintf('********************************************************************\n')
        fprintf('\t OFDM BER perfect   channel (simulation) ---> is %f\n',bitErr)
        fprintf('\t OFDM BER                (theory awgn  ) ---> is %f\n',bitErrTheoryAWGN)
        fprintf('********************************************************************\n')
    end
%------------------------------------------------------------------------------------    
