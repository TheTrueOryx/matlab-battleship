function [x,y] = dirNum(direction, currentX, currentY)
% Purpose: Generates an x and y that is next in the direction from the
% currentX and currentY
% syntax: [x,y] = dirNum(direction, currentX, currentY)
% Input variables:
%   direction: Scalar value describing what direction from currentX and currentY to fire
%   currentX: Scalar value that describes the last x value of a ship to be hit
%   currentY: Scalar value that describes the last y value of a ship to be hit
% Output variables:
%   x: A scalar value for the x location
%   y: A scalar value for the y location
%

%
% Created by:           Dean Boerrigter
% Section #:            DB-06
% Created On:           28 Apr 21
% Last Modified On:     28 Apr 21
%
% By submitting this program with my name, I affirm that the creation and
% modifications of this program are primarily my own work.

% Comments: - Orientations: (0-East, 1-North, 2-West, 3-South)
%------------------------------------------------------------------------

%Select x an y based off of direction
switch direction 
    case 0 %East
        x = currentX + 1;
        y = currentY;
    case 1 %North
        x = currentX;
        y = currentY - 1;
    case 2 %West
        x = currentX - 1;
        y = currentY;
    case 3 %South
        x = currentX;
        y = currentY + 1;
end