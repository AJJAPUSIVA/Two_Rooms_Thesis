function [deskPos,N,M, deskwidth, desklength] = getDeskPositi(w,l,h,r,w0,l0)
% w = roomWidth,
% l = roomLength
% h = deskHeight
% r = resolution
if nargin < 5 || nargin < 6
    w0 = r; % min distance from wall
    l0 = r; % min distance from wall
end
    deskwidth = w-w0/2;
    desklength= l-l0/2;
    x = w0:r:(w-w0);
    y = l0:r:(l-l0);
    N = length(x);
    M = length(y);
    [x,y] = meshgrid(x,y);
    % matrix to vector conversion
    x = x(:);
    y = y(:);
    deskPos = zeros(size(x,1),3);
    deskPos(:,1) = x;
    deskPos(:,2) = y;
    deskPos(:,3) = h;
