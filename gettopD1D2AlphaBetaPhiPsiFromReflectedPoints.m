function [d1,d2,a,b,p,s] = gettopD1D2AlphaBetaPhiPsiFromReflectedPoints(deskLedPositions,roomtopPos,TxrefPos)
% LedPos: position of the reference LED (N x 3)
% DeskPos: position of the desk (M x 3)
% RefPos: position of the reflected points (K x 3)

nLEDs = size(deskLedPositions,1);
nDesk = size(roomtopPos,1);
nRef  = size(TxrefPos,1);

% allocate memory
d1 = zeros(nDesk,nRef,nLEDs);
d2 = zeros(nDesk,nRef,nLEDs);
a  = zeros(nDesk,nRef,nLEDs);
b  = zeros(nDesk,nRef,nLEDs);
p  = zeros(nDesk,nRef,nLEDs);
s  = zeros(nDesk,nRef,nLEDs);

for n = 1 : nLEDs
    for m = 1 : nDesk
        % find distance between LED and the reflected points
        d1(m,:,n) = sqrt(...
            (TxrefPos(:,1)-deskLedPositions(n,1)).^2 + ...
            (TxrefPos(:,2)-deskLedPositions(n,2)).^2 + ...
            (TxrefPos(:,3)-deskLedPositions(n,3)).^2 );
        
        d2(m,:,n) = sqrt(...
            (TxrefPos(:,1)-roomtopPos(m,1)).^2 + ...
            (TxrefPos(:,2)-roomtopPos(m,2)).^2 + ...
            (TxrefPos(:,3)-roomtopPos(m,3)).^2 );
        
        % find phi and alpha
        d12D = sqrt(...
                (TxrefPos(:,1)-deskLedPositions(n,1)).^2 + ...
                (TxrefPos(:,2)-deskLedPositions(n,2)).^2 );
        p(m,:,n) = atan(  d12D./(deskLedPositions(n,3) - TxrefPos(:,3)) );
        a(m,:,n) = atan( (deskLedPositions(n,3) - TxrefPos(:,3))./ d12D );
    
        % find psi and beta
        d22D = sqrt(...
            (TxrefPos(:,1)-roomtopPos(m,1)).^2 + ...
            (TxrefPos(:,2)-roomtopPos(m,2)).^2 );
        s(m,:,n) = atan(  d22D./(TxrefPos(:,3) - roomtopPos(n,3))  );
        b(m,:,n) = atan( (TxrefPos(:,3) - roomtopPos(n,3)) ./ d22D );
    end
end