function [roomtopPos,T,O] = gettopRoomPositions(TxRoomWidth,TxRoomLength,TxRoomHeight,room_r)

    x = 0:room_r:TxRoomWidth;
    y = 0:room_r:TxRoomLength;
    T = length(x);
    O = length(y);
    [x,y] = meshgrid(x,y);
    % matrix to vector conversion
    x = x(:);
    y = y(:);
    roomtopPos = zeros(size(x,1),3);
    roomtopPos(:,1) = x;
    roomtopPos(:,2) = y;
    roomtopPos(:,3) = TxRoomHeight;