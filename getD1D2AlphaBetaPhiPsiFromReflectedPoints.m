function [d1,d2,a,b,p,s] = getD1D2AlphaBetaPhiPsiFromReflectedPoints(ledPos,deskPos,refPos)
% LedPos: position of the reference LED (N x 3)
% DeskPos: position of the desk (M x 3)
% RefPos: position of the reflected points (K x 3)

nLEDs = size(ledPos,1);
nDesk = size(deskPos,1);
nRef  = size(refPos,1);

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
            (refPos(:,1)-ledPos(n,1)).^2 + ...
            (refPos(:,2)-ledPos(n,2)).^2 + ...
            (refPos(:,3)-ledPos(n,3)).^2 );
        
        d2(m,:,n) = sqrt(...
            (refPos(:,1)-deskPos(m,1)).^2 + ...
            (refPos(:,2)-deskPos(m,2)).^2 + ...
            (refPos(:,3)-deskPos(m,3)).^2 );
        
        % find phi and alpha
        d12D = sqrt(...
                (refPos(:,1)-ledPos(n,1)).^2 + ...
                (refPos(:,2)-ledPos(n,2)).^2 );
        p(m,:,n) = atan(  d12D./(ledPos(n,3) - refPos(:,3)) );
        a(m,:,n) = atan( (ledPos(n,3) - refPos(:,3))./ d12D );
    
        % find psi and beta
        d22D = sqrt(...
            (refPos(:,1)-deskPos(m,1)).^2 + ...
            (refPos(:,2)-deskPos(m,2)).^2 );
        s(m,:,n) = atan(  d22D./(refPos(:,3) - deskPos(n,3))  );
        b(m,:,n) = atan( (refPos(:,3) - deskPos(n,3)) ./ d22D );
    end
end