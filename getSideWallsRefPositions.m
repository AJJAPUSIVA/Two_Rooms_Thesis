function [refPos,dA] = getSideWallsRefPositions(w,l,h,r)
% w = roomWidth,
% l = roomLength
% h = roomHeight
% r = resolution


% area of one segement 
dA = r^2;

% there are 4 side walls which we consider here. 
x = r/2:r:(w-r/2);  % points in x axis
y = r/2:r:(l-r/2);  % points in y axis
z = r/2:r:(h-r/2);  % points in z axis

N = length(x);
M = length(y);
K = length(z);


% side 1 and 3
[YLR,ZLR] = meshgrid(y,z);  % left and write wall
[XFB,ZFB] = meshgrid(x,z);  % front and back wall

refPos = [ones(M*K,1)*0,YLR(:),ZLR(:);...   % left wall
          ones(M*K,1)*w,YLR(:),ZLR(:);...   % right wall
          XFB(:),ones(N*K,1)*0,ZFB(:);...   % back wall
          XFB(:),ones(N*K,1)*l,ZFB(:)];     % fron wall



