function Results = OpticMain_TwoRoomfunc(varargin)
%% clear ------------------------------------------------------------------
if nargin == 0; %if number of input arguments is zero
    clear
    close all
    clc
    rng(0)
end
%--------------------------------------------------------------------------
%% Room1 controlling parameters--------------------------------------------
    Ctrl.ifPlotOrientation2D      = false;
    Ctrl.ifRoom1PlotOrientation3D      = false;
    Ctrl.ifRoom1PlotDistOfIllumination = false;
    Ctrl.ifRoom1PlotReflectionPoints   = false;
    Ctrl.ifRoom1PlotDistOfTotalRxPow   = true;
    Ctrl.ifRoom1PlotDistOfRmsDelay     = false;
    Ctrl.ifRoom1PlotChannelImpulse     = false;
    Ctrl.ifRoom1PlotSymbols            = true;%
    Ctrl.ifRoom1SaveResults            = false;
    Ctrl.ifRoom1FindChannelResponse    = true;%
    Ctrl.ifRoom1UseOokModulation       = true;%
    Ctrl.ifRoom1plotBER                = true;%
    Ctrl.ifRoom1ShowTexts              = true;%
    Ctrl.iftworoomBER                  = true;%
    Ctrl.ifplotroom1BER                = true;
%% Room2 controlling parameters
% controlling parameters
    Ctrl.ifUseMultipleLEDs        = false;
    
    Ctrl.ifPlotIofPhi             = false;
    Ctrl.ifPlotOrientation2D      = false;
    Ctrl.ifPlotOrientation3D      = false;
    Ctrl.ifPlotDistOfIllumination = false;
    Ctrl.ifPlotReflectionPoints   = false;
    Ctrl.ifPlotDistOfTotalRxPow   = true;
    Ctrl.ifPlotDistOfRmsDelay     = false;
    Ctrl.ifPlotChannelImpulse     = false;
    Ctrl.ifPlotSymbols            = true;%
    Ctrl.ifShowTexts              = true;
    Ctrl.ifSaveResults            = false;
    Ctrl.ifFindChannelResponse    = true;%
    Ctrl.ifUseOokModulation       = true;%
    Ctrl.ifplotroom12BER          = true;
    Ctrl.ifUseOfdmModulation      = false;
    Ctrl.ifplotBER                = true;
%% system parameters ------------------------------------------------------
% controlling parameters
% room1 control parameters
deskLedHalfPowerSemiAngle = 60*pi/180; %in radian
deskLedCenterLuminousIntensity = 0.73; %cd
desknumberOfLedsInEachGroup = 3600;
deskLedFieldOfViewAngle = 50*pi/180; %in radian
CeilingDetectorPhysicalArea = 10^-4; %in m^2
CeilingGainOfOpticalArea = 1;
TxRoomWidth = 5;
TxRoomLength = 5;
TxRoomHeight = 3;
TxDeskHeight = 0.85;
TxrefCoeffcientWall = 0.8; %reflection coefficent of walls
TxrefCoeffCeiling = 0;%#ok
TxrefCoeffFloor = 0; %ok
numberOfdeskLeds = 1;
TxDeskPositionResolution  =0.1;

%room2 control parameters

halfPowerSemiAngle      = 60*pi/180;        % in radian
centerLuminousIntensity = 0.73;             % in cd
numberOfLedInEachGroup  = 3600;
fieldOfViewAngle        = 50*pi/180;        % in radian
detectorPhysicalArea    = 10^-4;            % in m^2
gaiOfAnOpticalFilter    = 1;    
roomWidth               = 5;
roomLength              = 5;
roomHeight              = 3;
deskHeight              = 0.85;
refCoeffWall            = 0.8;              % reflection coefficient from walls
refCoeffCeiling         = 0;%#ok
refCoeffFloor           = 0;%#ok
NumOfLeds               = 8;
deskPositionResolution  =0.1;

%%common parameters 
n      = 1.46;             % n in equation (6)
lightSpeed = 3e8;
i0 = 2e-4;% leakage current in amps
k = 1.38e-23;%Boltzmann constant J/K
q = 1.602e-19;%Charge of electron in C
V_led = -0.2:0.01:0.7;%led voltage(V)
t_F = 27;%temperature in F
n_led = 1.7;%led emission coefficient
A_1 = 1.044;
A_2 = 1.097;
lambda_i = 800;
lambda_d = 420:1:1120;% photodiode wavelength(nm)
lambda_1 = 449.67+4.81;
Delta_lambda_1 =23.91+2.92;
lambda_2 = 563.49+9.75;
Delta_lambda_2 = 133.84+12.98;
K_m = 683; %%maximum visibility ~683 lm/w at 555nm
transmitPower  = 4*10-6;        %  watts
deskMinimumDistFromWall           = 0.5;
reflectorPositionResolution       = 0.2;
% related to noise
SNRdB                             = 0.1;% signal to noise ration

% related to pulse width modulation
upsampleRate                      = 27;
pwmBitRate                        = 20e6;
pwmBitDuration                    = 1/pwmBitRate;
pwmSampleTime                     = pwmBitDuration / upsampleRate;
txtToTransmit                     = ['This is a paragraph to test. OpTic Gaming was established ',...
'in 2006 by OpTic "Kr3w" and Ryan "J" Musselman as a Call of ',...
'Duty sniping team.'];
%--------------------------------------------------------------------------
%% Override parameters from function argument -----------------------------
% Here we override the values of the internal parameters from outside
% The number of argument has to be an even number with the following format
% MU_MSDD_DL_main_func('parameter1Name',parameter1Value,...
%                      'parameter2Name',parameter2Value,...
%                      ...
%                      'parameterNName',parameterNValue,...
%                      )
if nargin > 0   % if number of argument is greater than 0
    if nargin == 1
        if isstruct(varargin{1})
            F = fields(varargin{1});
            for f = 1 : length(F)
                V = varargin{1}.(F{f}) ;%#ok
                eval(sprintf('%s = %s;',F{f},'V'))
            end
        end
    else
        for n = 1 : nargin /2
            % this is a coding technique
            if length(varargin{2*n}) == 1
                if isnumeric(varargin{2*n})
                    eval(sprintf('%s = %d;',varargin{2*n-1},varargin{2*n}))
                elseif isstruct(varargin{2*n})
                    F = fields(varargin{2*n});
                    for f = 1 : length(F)
                        if ischar(varargin{2*n}.(F{f}))
                            eval(sprintf('%s.%s = ''%s'';',varargin{2*n-1},F{f},varargin{2*n}.(F{f})))
                        else
                            eval(sprintf('%s.%s = %d;',varargin{2*n-1},F{f},varargin{2*n}.(F{f})))
                        end
                    end
                else
                    error('not supported.')
                end
            else
                if ischar(varargin{2*n})
                    eval(sprintf('%s = ''%s'';',varargin{2*n-1},varargin{2*n}))
                else
                    r = length(varargin{2*n}) - 1;
                    eval(sprintf(['%s = [',repmat('%d,',1,r),'%d];'],varargin{2*n-1},varargin{2*n}))
                end
            end
        end
    end
else
end
%--------------------------------------------------------------------------
%% room1 input distributions------------------------------------------------
[i_led] = LedCurrent(i0,k,q,V_led,t_F,n_led);
[S,S_b,S_r] =  RelativeSpectralIntensity(A_1, A_2, lambda_i, lambda_1, lambda_2, Delta_lambda_1, Delta_lambda_2);
[L_flux] = LuminousFlux(K_m);
I01      = deskLedCenterLuminousIntensity;
m1       = -log(2)/log(cos(deskLedHalfPowerSemiAngle));
I1       = @(phi) TxI01*cos(phi).^m1;
%% Eh and Hd for direct path ----------------------------------------------
% possible desk positions with a given resolution
deskMd = deskMinimumDistFromWall;   % minimum distance from side walls
room_r  = TxDeskPositionResolution;
[roomtopPos,T,O] = gettopRoomPositions(TxRoomWidth,TxRoomLength,TxRoomHeight,room_r);
[desk_Pos,N,M,deskwidth, desklength] = getDeskPositi(TxRoomWidth,TxRoomLength,TxDeskHeight,room_r,deskMd,deskMd);
deskLedPositions = [deskwidth/2, desklength/2, TxDeskHeight];
[topDd,topPhi,topPsi] = getDistroomtopPhiPsiForDirectPath(deskLedPositions,roomtopPos);

if Ctrl.ifPlotOrientation2D 
 figure(121)
            clf
            plot(deskLedPositions(:,1),deskLedPositions(:,2),'*r')
            hold on 
            plot([0 0 1 1 0]*deskwidth,...
                 [0 1 1 0 0]*desklength,'b','linewidth',1.5)
            grid on
            xlabel('Desk length in meter')
            ylabel('Desk width in meter')
            title('LED position on Desk in Room1 (2D)')
            legend('LED','Desk boundaries')
            drawnow
end
 if Ctrl.ifRoom1PlotOrientation3D
        figure(113)
            clf
            
            plot3(deskLedPositions(:,1),...
                  deskLedPositions(:,2),...
                  deskHeight*ones(numberOfdeskLeds,1),'*r','linewidth',1.5)
            hold on 
            plot3(2.5,2.5,3,'r','linewidth',1.5)
            hold on
            % plot room 
            plot3([0 0 1 1 0 0 0 0 0 1 1 1 1 1 1 0 ]*roomWidth,...
                  [0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 ]*roomLength,...
                  [0 0 0 0 0 1 1 0 1 1 0 1 1 0 1 1 ]*roomHeight,'b','linewidth',1.5)
            % plot desk
            plot3([0 0 1 1 0 0 0 0 0 1 1 1 1 1 1 0 ]*roomWidth,...
                  [0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 ]*roomLength,...
                  [0 0 0 0 0 1 1 0 1 1 0 1 1 0 1 1 ]*deskHeight,'g--','linewidth',1.5)
            [x,y] = meshgrid(linspace(0,1,10)*roomWidth,...
                             linspace(0,1,10)*roomLength);
            mesh(x,y,ones(size(x))*deskHeight)
            xlabel('Length')
            ylabel('Width')
            zlabel('Height')
            axis square
            title('LED on Desk and Detector on top of ceiling in Room1')
            legend('LED positions','APD position','Room boundaries','Desk surface')
            drawnow
 end
%find illumination E_hor for thr top points
topEdhor   = I01 .* cos(topPhi).^m1./ (topDd.^2) .* cos(topPsi) ;
% find Hd for direct pass for each LED
% find g
topg = n.^2/sin(deskLedFieldOfViewAngle).^2 .* (topPsi >= 0 & topPsi <= deskLedFieldOfViewAngle);
% find Hd for each LED at each desk position
topTs = CeilingGainOfOpticalArea;
topA  = CeilingDetectorPhysicalArea;
topHd = (m1+1)*topA./(2*pi*topDd.^2).* cos(topPhi).^m1 .* topTs .* topg .* cos(topPsi);

% find the propagation time of each path
toptd = topDd ./ lightSpeed;
%% Eh and dH for direct path ----------------------------------------------
% ger reflection position
r = reflectorPositionResolution;
[TxrefPos,topdA] = getSideWallsRefPositions(TxRoomWidth,TxRoomLength,TxRoomHeight,r);
% find number of reflected points
nroomtopPoint = size(roomtopPos,1);%#ok
nRefPoints = size(TxrefPos,1);%#ok
% find d1,d2, alpha, beta, phi, spi of the reflected points
[topD1,topD2,topalpha,topbeta,topPhiR,topPsiR] = gettopD1D2AlphaBetaPhiPsiFromReflectedPoints(deskLedPositions,roomtopPos,TxrefPos);
% find gR
topgR = n.^2/sin(deskLedFieldOfViewAngle).^2 .* (topPsiR >= 0 & topPsiR <= deskLedFieldOfViewAngle);
% find dH ( not sure if 2*pi^2 or 2*pi (different in several
% references)

topdH = (m1+1)*topA./(2*pi^2.*topD1.^2.*topD2.^2).*TxrefCoeffcientWall.*topdA.*cos(topPhiR).^m1.* cos(topalpha) .* ...
cos(topbeta).*topTs.*topgR.*cos(topPsiR);

% find time of reflection
toptr = (topD1+ topD2)./lightSpeed;
[S_rel] = PhotoDiodeSensitivity(lambda_d);
[Pt] = PowerTransmitted(K_m);
%-----------------------------------------------------------------------------------
%% total power ------------------------------------------------------------
% find total power at each point of the desk position
topPt = Pt;

topPT = sum(topPt.*topHd,2)*1 + sum(sum(topPt.*topdH,3),2);
vvvv = 10./topPT;
Results.vvvv = vvvv;

figure(1)
        clf
            mesh(reshape(roomtopPos(:,1),T,O),...
                 reshape(roomtopPos(:,2),T,O),...
                 reshape(topPT          ,T,O))
            xlabel('x in meter')
            ylabel('y in meter')
            zlabel('power')
            title('Room1 power distribution')
            grid on
            colorbar
            colormap jet
            drawnow
%----------------------------------------------------------------------------------
%% find Trms for any desp position ----------------------------------------
toptau_avg = (sum(topPt.*topHd.*toptd.^1,2) + sum(sum(topPt.*topdH.*toptr.^1,3),2)) ./ topPT;
toptau_pow = (sum(topPt.*topHd.*toptd.^2,2) + sum(sum(topPt.*topdH.*toptr.^2,3),2)) ./ topPT;
toptau_RMS = sqrt(toptau_pow-toptau_avg.^2);

% this part is the most important part
% select a desk position
toproomPosId = 841;
% time bins
toptdSel     = toptd(toproomPosId,:);
toptrSel     = toptr(toproomPosId,:,:);
topHdSel     = topHd(toproomPosId,:,:);
topdHSel     = topdH(toproomPosId,:,:);
% collect time and power in an array and sort them
toptimePow      = [[toptdSel(:);toptrSel(:)],topPt*[topHdSel(:);topdHSel(:)]];
[~,topsortInd]  = sort(toptimePow(:,1));
toptimePow      = toptimePow(topsortInd,:);

toptimeBins     = (0: pwmSampleTime : (pwmSampleTime+max(toptimePow(:,1)))).';
topchanPow      = zeros(length(toptimeBins)-1,1);
for k = 1 : length(toptimeBins)-1
    % select the paths whos time falls between two bins
    topInd = toptimePow(:,1) >= toptimeBins(k) & toptimePow(k) < toptimeBins(k+1);
    topchanPow(k) = sum(toptimePow(topInd,1));
end
topInd1 = find(topchanPow ~= 0,1,'first');
topInd2 = find(topchanPow ~= 0,1,'last');
topchanPow = topchanPow(topInd1:topInd2);% select non zero part of the channel
%% room1 OOK modultation-----------------------------------------------------
BitError = [];
for kk = 1:length(topPT)
if ~isempty(txtToTransmit)
    % convert the message to bits
    deskbits = de2bi(uint8(txtToTransmit),8);
    deskbits = deskbits(:);
    desksymbols = deskbits;
    nDeskSymbols = length(desksymbols);
else
    nDeskSymbols = 20;                  % number of symbols
    rng(0)
    desksymbols  = randn(nDeskSymbols,1) > 0; % generate 0 and 1
end
% upsampling
deskTxupSymbols    = rectpulse(double(desksymbols),upsampleRate);
% path the information through channel
ceilRxUpSymbols = filter(topPT(kk,:),1,deskTxupSymbols);
% add noise
ch1NoisyUpSymbols = awgn(ceilRxUpSymbols,SNRdB,'measured');
% filter noisy signal
ch1FilteredSymbol = filter(1/upsampleRate*ones(upsampleRate,1),1,ch1NoisyUpSymbols);
% downsample
ceilDelay     = floor((upsampleRate-1)/2 + (length(topPT(kk,:))-1));
ceilDnSymbols = ch1FilteredSymbol((ceilDelay : upsampleRate : end),:);
% detection
ceilDnSymbols    = ceilDnSymbols > max(ceilDnSymbols)/2;
ceilDetUpSymbols = rectpulse(double(ceilDnSymbols),upsampleRate);
if ~isempty(txtToTransmit)
    % detect message
    DetMsg = reshape(ceilDnSymbols,nDeskSymbols/8,8);
    DetMsg = bi2de(DetMsg);    % BIT TO BYTE
    DetMsg = char(DetMsg.');    % byte to text
    BitError =[BitError, nnz(ceilDnSymbols~=deskbits)/length(deskbits)];
    fprintf('---------------------------------------------------\n')
    fprintf('Tx message in room2 is:\n %s \n',txtToTransmit)
    fprintf('Rx message in room2 is:\n %s \n',DetMsg)
    fprintf('BER is %f \n',nnz(ceilDnSymbols~=deskbits)/length(deskbits))
    fprintf('---------------------------------------------------\n')
    [MinumumBitERR BitERR_Index] = min(BitError)
end
 end
figure(222)
    clf
            mesh(reshape(roomtopPos(:,1),T,O),...
                 reshape(roomtopPos(:,2),T,O),...
                 reshape(BitError ,T,O))
            xlabel('Length in meter')
            ylabel('Width in meter')
            zlabel('BER')
            title('Room1 BER distribution on ceiling')
            grid on
            colorbar
            colormap jet
            drawnow
if Ctrl.iftworoomBER
 High_power = topPT(BitERR_Index,:);
 Results.High_power  = High_power;
 if ~isempty(txtToTransmit)
    % convert the message to bits
    deskbits = de2bi(uint8(txtToTransmit),8);
    deskbits = deskbits(:);
    desksymbols = deskbits;
    nDeskSymbols = length(desksymbols);
else
    nDeskSymbols = 20;                  % number of symbols
    rng(0)
    desksymbols  = randn(nDeskSymbols,1) > 0; % generate 0 and 1
end
% upsampling
deskTxupSymbols    = rectpulse(double(desksymbols),upsampleRate);
% path the information through channel
ceilRxUpSymbols = filter(topPT(kk,:),1,deskTxupSymbols);
% add noise
ch1NoisyUpSymbols = awgn(ceilRxUpSymbols,SNRdB,'measured');
% filter noisy signal
ch1FilteredSymbol = filter(1/upsampleRate*ones(upsampleRate,1),1,ch1NoisyUpSymbols);
% downsample
ceilDelay     = floor((upsampleRate-1)/2 + (length(topPT(kk,:))-1));
ceilDnSymbols = ch1FilteredSymbol((ceilDelay : upsampleRate : end),:);
% detection
ceilDnSymbols    = ceilDnSymbols > max(ceilDnSymbols)/2;
ceilDetUpSymbols = rectpulse(double(ceilDnSymbols),upsampleRate);
if ~isempty(txtToTransmit)
    % detect message
    DetMsg = reshape(ceilDnSymbols,nDeskSymbols/8,8);
    DetMsg = bi2de(DetMsg);    % BIT TO BYTE
    DetMsg = char(DetMsg.');    % byte to text
 fprintf('---------------------------------------------------\n')
    fprintf('Tx message in room2 is:\n %s \n',txtToTransmit)
    fprintf('Rx message in room2 is:\n %s \n',DetMsg)
    fprintf('BER is %f \n',nnz(ceilDnSymbols~=deskbits)/length(deskbits))
    fprintf('---------------------------------------------------\n')
    Room1DetMsg = DetMsg;
    Results.Room1DetMSg = DetMsg; 
    Results.roomtopPosX = roomtopPos(:,1);
    Results.roomtopPosY = roomtopPos(:,2);
end
end
%% Dependent parameters ---------------------------------------------------
    if Ctrl.ifUseMultipleLEDs
        
        if NumOfLeds == 4
            % make LED position as a function of room size
            ledPositions        = [-1,-1,1;...
                                   -1, 1,1;...
                                    1,-1,1;...
                                    1, 1,1] .* ...
                                repmat([0.3*roomWidth,0.3*roomLength,roomHeight-0.5],NumOfLeds,1) + ...
                                repmat([roomWidth/2,roomLength/2,0],NumOfLeds,1);
        elseif NumOfLeds == 8
            ledPositions        =[...
                                  [-1,-1,1;...
                                   -1, 1,1;...
                                    1,-1,1;...
                                    1, 1,1] .* ...
                                repmat([0.35*roomWidth,0.35*roomLength,roomHeight-0.5],NumOfLeds/2,1) + ...
                                repmat([roomWidth/2,roomLength/2,0],NumOfLeds/2,1);
                                  [-1,-1,1;...
                                   -1, 1,1;...
                                    1,-1,1;...
                                    1, 1,1] .* ...
                                repmat([0.20*roomWidth,0.20*roomLength,roomHeight-0.5],NumOfLeds/2,1) + ...
                                repmat([roomWidth/2,roomLength/2,0],NumOfLeds/2,1) ...
                                ];
        end
            
        % 
    else
        ledPositions            = [roomWidth/2,roomLength/2,roomHeight-0.5];
    end
    % find number of LEDs
    I0      = centerLuminousIntensity;
    m       = -log(2)/log(cos(halfPowerSemiAngle));
    I       = @(phi) I0*cos(phi).^m;
    
    numberOfLeds            = size(ledPositions,1);
    
    pwmBitDuration                    = 1/pwmBitRate;  
    pwmSampleTime                     = pwmBitDuration / upsampleRate;
    
%--------------------------------------------------------------------------    
%% Orientation plots ------------------------------------------------------
    if Ctrl.ifPlotIofPhi
        % plot I(phi)
        figure(1)
            clf
            phi = 0:1/100:pi/2;
            plot(phi,I(phi),'b','linewidth',1.5)
            hold on 
            plot([1    1]*halfPowerSemiAngle,[0 1]    ,'r--')
            plot([0 pi/2]                   ,[1 1]*I0/2,'r--')
            xlabel('\phi [rad]')
            ylabel('I(\phi)')
            grid on
            title('Half power semi angle')
            drawnow
    end
    if Ctrl.ifPlotOrientation2D
        % plot LEDs orientation in 2D
        figure(2)
            clf
            plot(ledPositions(:,1),ledPositions(:,2),'*r')
            hold on 
            plot([0 0 1 1 0]*roomWidth,...
                 [0 1 1 0 0]*roomLength,'b','linewidth',1.5)
            grid on
            xlabel('Ceiling length in meter')
            ylabel('Ceiling width in meter')
            title('LED position on ceiling in Room2(2D)')
            legend('LED','Ceiling boundaries')
            drawnow
    end
     if Ctrl.ifPlotOrientation3D
        figure(3)
            clf
            plot3(ledPositions(:,1),...
                  ledPositions(:,2),...
                  roomHeight*ones(numberOfLeds,1),'*r','linewidth',1.5)
            hold on 
            plot3(4.5,0.5,0.85,'rs','linewidth',1.5)
            hold on
            % plot room 
            plot3([0 0 1 1 0 0 0 0 0 1 1 1 1 1 1 0 ]*roomWidth,...
                  [0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 ]*roomLength,...
                  [0 0 0 0 0 1 1 0 1 1 0 1 1 0 1 1 ]*roomHeight,'b','linewidth',1.5)
            % plot desk
            plot3([0 0 1 1 0 0 0 0 0 1 1 1 1 1 1 0 ]*roomWidth,...
                  [0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 ]*roomLength,...
                  [0 0 0 0 0 1 1 0 1 1 0 1 1 0 1 1 ]*deskHeight,'g--','linewidth',1.5)
            [x,y] = meshgrid(linspace(0,1,10)*roomWidth,...
                             linspace(0,1,10)*roomLength);
            mesh(x,y,ones(size(x))*deskHeight)
            xlabel('Length')
            ylabel('Width')
            zlabel('Height')
            axis square
            title('LED on top of ceiling and Detector on Desk in Room2')
            legend('LED positions','APD position','Room boundaries','Desk surface')
            drawnow
    end
%--------------------------------------------------------------------------    
%% Eh and Hd for direct path ----------------------------------------------
    % possible desk positions with a given resolution
    mD = deskMinimumDistFromWall;   % minimum distance from side walls
    r  = deskPositionResolution;
    [deskPos,N,M] = getDeskPositions(roomWidth,roomLength,deskHeight,r,mD,mD);
    % get distance between desk possible position and LEDs
    [Dd,Phi,Psi] = getDistPhiPsiForDirectPath(ledPositions,deskPos);
    % find illumination E_hor for the points
    Edhor   = I0 .* cos(Phi).^m ./ (Dd.^2) .* cos(Psi) ;
    % take sum over all number of LEDs
    Edhor   = sum(Edhor,2)*numberOfLedInEachGroup;
    
    % find Hd for direct pass for each LED\
        % find g
        g = n.^2/sin(fieldOfViewAngle).^2 .* (Psi >= 0 & Psi <= fieldOfViewAngle);
        
        % find Hd for each LED at each desk position
        Ts = gaiOfAnOpticalFilter;
        A  = detectorPhysicalArea;
        Hd = (m+1)*A./(2*pi*Dd.^2).* cos(Phi).^m .* Ts .* g .* cos(Psi);
        
        % find the propagation time of each path
        td = Dd ./ lightSpeed;
        
    if Ctrl.ifPlotDistOfIllumination
        % plot in mesh format
        figure(4)
        clf
            mesh(reshape(deskPos(:,1),N,M),...
                 reshape(deskPos(:,2),N,M),...
                 reshape(Edhor       ,N,M))
            xlabel('x in meter')
            ylabel('y in meter')
            zlabel('Illuminance (lx)')
            title(sprintf(...
                ['EHd -> Illuminance distribution with LED semiangle of %.0f degree\n',...
                 'Min is %0.1f lx, max is %0.1f lx, and avg is %0.1f lx'],...
                halfPowerSemiAngle*180/pi,min(Edhor),max(Edhor),mean(Edhor)))
            grid on
            colorbar
            colormap jet
            drawnow
    end    
%--------------------------------------------------------------------------    
%% Eh and dH for direct path ----------------------------------------------
    % ger reflection position
    r = reflectorPositionResolution;
    [refPos,dA] = getSideWallsRefPositions(roomWidth,roomLength,roomHeight,r);
    if Ctrl.ifPlotReflectionPoints
        figure(5)
            clf
            plot3(refPos(:,1),refPos(:,2),refPos(:,3),'.')
            axis([0 roomWidth 0 roomLength 0 roomHeight])
            axis square
            grid on
            xlabel('x')
            ylabel('y')
            zlabel('z')
            title('position of the reflection points')
            drawnow
    end
    % find number of reflected points
    nDeskPoint = size(deskPos,1);%#ok
    nRefPoints = size(refPos,1);%#ok
    % find d1,d2, alpha, beta, phi, spi of the reflected points 
    [D1,D2,alpha,beta,PhiR,PsiR] = getD1D2AlphaBetaPhiPsiFromReflectedPoints(ledPositions,deskPos,refPos);
    % find gR
    gR = n.^2/sin(fieldOfViewAngle).^2 .* (PsiR >= 0 & PsiR <= fieldOfViewAngle);
    % find dH ( not sure if 2*pi^2 or 2*pi (different in several
    % references)
    dH = (m+1)*A./(2*pi^2.*D1.^2.*D2.^2).*refCoeffWall.*dA.*cos(PhiR).^m.* cos(alpha) .* ...
        cos(beta).*Ts.*gR.*cos(PsiR);
    % find time of reflection
    tr = (D1+ D2)./lightSpeed;
%--------------------------------------------------------------------------    
%% total power ------------------------------------------------------------
    % find total power at each point of the desk position
    Pt = transmitPower;
    PT = sum(Pt.*Hd,2)*1 + sum(sum(Pt.*dH,3),2);
    if Ctrl.ifPlotDistOfTotalRxPow
        figure(6)
        clf
            mesh(reshape(deskPos(:,1),N,M),...
                 reshape(deskPos(:,2),N,M),...
                 reshape(PT          ,N,M))
            xlabel('x in meter')
            ylabel('y in meter')
            zlabel('power')
            title('Room2 power distribution')
            grid on
            colorbar
            colormap jet
            drawnow
    end
%--------------------------------------------------------------------------    
%% find Trms for any desp position ----------------------------------------
    tau_avg = (sum(Pt.*Hd.*td.^1,2) + sum(sum(Pt.*dH.*tr.^1,3),2)) ./ PT;
    tau_pow = (sum(Pt.*Hd.*td.^2,2) + sum(sum(Pt.*dH.*tr.^2,3),2)) ./ PT;
    tau_RMS = sqrt(tau_pow-tau_avg.^2);
    if Ctrl.ifPlotDistOfRmsDelay
        figure(7)
        clf
            mesh(reshape(deskPos(:,1),N,M),...
                 reshape(deskPos(:,2),N,M),...
                 reshape(tau_RMS     ,N,M))
            xlabel('x in meter')
            ylabel('y in meter')
            zlabel('RMS delay')
            title('RMS delay distribution')
            grid on
            colorbar
            colormap jet
            drawnow
    end   
    if Ctrl.ifShowTexts
        fprintf('Maximum delay spread is %0.2f ns \n',max(tau_RMS(:))*1e9)
        fprintf('Rb can be at most %0.2f Mega-bit/sec \n',1e-6/(10*max(tau_RMS(:))))
    end
    Results.deskPosX = reshape(deskPos(:,1),N,M);
    Results.deskPosY = reshape(deskPos(:,2),N,M);
    Results.tau_RMS  = reshape(tau_RMS     ,N,M);
    Results.DataRate =  1./(10*(Results.tau_RMS));
    
    Results.MaxDelaySpread = max(tau_RMS(:));
    Results.MaxDataRate    = 1/(10*max(tau_RMS(:)));
%--------------------------------------------------------------------------    
%% find channel response --------------------------------------------------
if Ctrl.ifFindChannelResponse
   % this part is the most important part
   % select a desk position
   deskPosId = 120;
   % time bins
   tdSel     = td(deskPosId,:);
   trSel     = tr(deskPosId,:,:);
   HdSel     = Hd(deskPosId,:,:);
   dHSel     = dH(deskPosId,:,:);
   
   % collect time and power in an array and sort them
   timePow      = [[tdSel(:);trSel(:)],Pt*[HdSel(:);dHSel(:)]];
   [~,sortInd]  = sort(timePow(:,1));
   timePow      = timePow(sortInd,:);
   
   timeBins     = (0: pwmSampleTime : (pwmSampleTime+max(timePow(:,1)))).';
   chanPow      = zeros(length(timeBins)-1,1);
   for k = 1 : length(timeBins)-1
       % select the paths whos time falls between two bins
       Ind = timePow(:,1) >= timeBins(k) & timePow(k) < timeBins(k+1);
       chanPow(k) = sum(timePow(Ind,2));
   end

   if Ctrl.ifPlotChannelImpulse
        figure(8)
        clf
            plot(timeBins(1:end-1)*1e9,chanPow);
            xlabel('time in ns')
            ylabel('power')
            title(sprintf('channel impulse response at position [%0.2f,%0.2f]',...
                deskPos(deskPosId,1),deskPos(deskPosId,2)))
            grid on
            drawnow
            
   end
   % once channel is calculated we can implement any communication
   % modulation
   Ind1 = find(chanPow ~= 0,1,'first');
   Ind2 = find(chanPow ~= 0,1,'last');
   chanPow = chanPow(Ind1:Ind2); % select non zero part of the channel
   Results.chanPow = chanPow;
else
    return
end
txtToTransmit2 = Room1DetMsg;
%--------------------------------------------------------------------------    
%% modulation -------------------------------------------------------------
if Ctrl.ifUseOokModulation
    BER_msgs = []
    for jj = 1:length(PT)
    if ~isempty(txtToTransmit2)
        % convert the message to bits
        bits = de2bi(uint8(txtToTransmit),8);
        bits = bits(:);
        symbols = bits;
        nSymbols = length(symbols);
    else
        nSymbols = 20;                  % number of symbols
        rng(0)
        symbols  = randn(nSymbols,1) > 0; % generate 0 and 1
    end
    % upsampling
    upSymbols    = rectpulse(double(symbols),upsampleRate);
    
    % path the information through channel
    rxUpSymbols = filter(PT(jj,:),1,upSymbols);
   
    % add noise
    noisyUpSymbols = awgn(rxUpSymbols,SNRdB,'measured');
   
    % filter noisy signal
    filteredSymbol = filter(1/upsampleRate*ones(upsampleRate,1),1,noisyUpSymbols);
    
    % downsample
    delay     = floor((upsampleRate-1)/2 + (length(PT(jj,:))-1));
    dnSymbols = filteredSymbol(delay : upsampleRate : end);
    
    % detection 
    dnSymbols    = dnSymbols > max(dnSymbols)/2;
    detUpSymbols = rectpulse(double(dnSymbols),upsampleRate);

    if ~isempty(txtToTransmit2)
        % detect message
        DetMsg = reshape(dnSymbols,nSymbols/8,8);
        DetMsg = bi2de(DetMsg);    % BIT TO BYTE
        DetMsg = char(DetMsg.');    % byte to text
        BER_msgs =[BER_msgs, nnz(dnSymbols~=bits)/length(bits)];
        Results.BER_msgs = BER_msgs;
        [MinumumBER BER_Index] = min(BER_msgs)
        
        fprintf('---------------------------------------------------\n')
        fprintf('Tx message is:\n %s \n',txtToTransmit)
        fprintf('Rx message is:\n %s \n',DetMsg)
        fprintf('BER is %f \n',nnz(dnSymbols~=bits)/length(bits))
        fprintf('---------------------------------------------------\n')
        Results.DetMsg = DetMsg;
        
    end
    end
    if Ctrl.ifplotroom12BER
    figure(4)
    clf
            mesh(reshape(deskPos(:,1),N,M),...
                 reshape(deskPos(:,2),N,M),...
                 reshape(BER_msgs    ,N,M))
            xlabel('Length in meter')
            ylabel('Width in meter')
            zlabel('BER')
            title('Room2 BER distribution on desk')
            grid on
            colorbar
            colormap jet
            drawnow
end

end
if Ctrl.ifPlotSymbols
        time = (0:(length(upSymbols)-1)).'.*pwmSampleTime;
        figure(9)
            clf
            ax(1) = subplot(5,1,1);
                stairs(time*1e6,upSymbols)
                ylim([-.5 1.5])
                title('tx signal')
                grid on
            ax(2) = subplot(5,1,2);
                time = (0:(length(rxUpSymbols)-1)).'.*pwmSampleTime;
                stairs(time*1e6,rxUpSymbols)
                title('rx signal with reflection')
                grid on
                ylim([-0.5 1.5]*max(rxUpSymbols))
            ax(3) = subplot(5,1,3);
                time = (0:(length(noisyUpSymbols)-1)).'.*pwmSampleTime;
                stairs(time*1e6,noisyUpSymbols)
                title('noisy signal with reflection')
                grid on
                ylim([-0.5 1.5]*max(noisyUpSymbols))
            ax(4) = subplot(5,1,4);
                time = (0:(length(filteredSymbol)-1)).'.*pwmSampleTime;
                stairs(time*1e6,filteredSymbol)
                title('filtered signal (moving avg)')
                grid on
                ylim([-0.5 1.5]*max(filteredSymbol))
            ax(4) = subplot(5,1,5);
                time = (0:(length(detUpSymbols)-1)).'.*pwmSampleTime;
                stairs(time*1e6,detUpSymbols)
                title('detected')
                grid on
                ylim([-.5 1.5])
                xlabel('time us')
            linkaxes(ax,'x')
            drawnow
end

%-------------------------------------------------------------------------- 
%% OFDM modulation --------------------------------------------------------
    if Ctrl.ifUseOfdmModulation
        Results.OFDM = ofdmModulation_func(SNRdB,chanPow,upsampleRate);
    end
%-------------------------------------------------------------------------- 
% save -------------------------------------------------------------------
if Ctrl.ifSaveResults
    % this information can be used further in communication channel
    save('data.mat','Hd','dH','td','tr')
end
end








