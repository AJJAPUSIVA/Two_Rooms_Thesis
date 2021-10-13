function [d,p,s] = getDistPhiPsiForDirectPath(ledPos,deskPos)
% [d,p,s] = getDistPhiPsiForDirectPath(ledPos,deskPos)
% this function calculates distance between LED and Desk, Phi angle, and
% Psi angle (incident angle)

% find number of LEDs
nLEDs  = size(ledPos,1);

% find number of desk positions
nDesks = size(deskPos,1);

% allocate memory 
d = zeros(nDesks,nLEDs);
p = zeros(nDesks,nLEDs);
s = zeros(nDesks,nLEDs);

for n = 1 : nLEDs
   % find distance between points 
   d(:,n)      = ...
       sqrt((deskPos(:,1)-ledPos(n,1)).^2 + ...
            (deskPos(:,2)-ledPos(n,2)).^2 + ...
            (deskPos(:,3)-ledPos(n,3)).^2 );
        
   % find angle of irradiance     
   d2D = sqrt((deskPos(:,1)-ledPos(n,1)).^2 + ...
              (deskPos(:,2)-ledPos(n,2)).^2);          
   p(:,n) = atan(d2D./(ledPos(n,3)-deskPos(:,3)));
   
   % find angle of incident (which is the same as phi in this case)
   s(:,n) = atan(d2D./(ledPos(n,3)-deskPos(:,3)));                   
end