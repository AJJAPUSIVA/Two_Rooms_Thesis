function [topd,topp,tops] = getDistroomtopPhiPsiForDirectPath(deskLedPositions,roomtopPos)
% [d,p,s] = getDistPhiPsiForDirectPath(ledPos,deskPos)
% this function calculates distance between LED and Desk, Phi angle, and
% Psi angle (incident angle)

% find number of LEDs
ndeskLEDs  = size(deskLedPositions,1);

% find number of room to positions
nroomPos = size(roomtopPos,1);

% allocate memory 
topd = zeros(nroomPos,ndeskLEDs);
topp = zeros(nroomPos,ndeskLEDs);
tops = zeros(nroomPos,ndeskLEDs);

for n = 1 : ndeskLEDs
   % find distance between points 
   topd(:,n)      = ...
       sqrt((roomtopPos(:,1)-deskLedPositions(n,1)).^2 + ...
            (roomtopPos(:,2)-deskLedPositions(n,2)).^2 + ...
            (roomtopPos(:,3)-deskLedPositions(n,3)).^2 );
        
   % find angle of irradiance     
   d2D = sqrt((roomtopPos(:,1)-deskLedPositions(n,1)).^2 + ...
              (roomtopPos(:,2)-deskLedPositions(n,2)).^2);
   dist = deskLedPositions(n,3)-roomtopPos(:,3);
   idx = dist<0;
   dist(idx)= -dist(idx);
   topp(:,n) = atan(d2D./dist);
   
   % find angle of incident (which is` the same as phi in this case)
   tops(:,n) = atan(d2D./dist);                  
end