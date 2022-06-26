function [x,y] = gridNum(boardvec)
% Purpose: Generates a random x and y that are either both even or both odd
% syntax: [x,y] = gridNum(boardvec)
% Input variables:
%   boardvec: A vector that stores the location data for the board
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

% Comments: N/A
%------------------------------------------------------------------------

%Chooses a random location on a checkerboard pattern
x = randi([1,length(boardvec)]); %<SM:RANDGEN>

%IF x is odd
if mod(x,2) ~= 0
    %y should be odd
    y = randi([1,length(boardvec)/2])*2 - 1;
else %x is even
    %y should be even
    y = randi([1,length(boardvec)/2])*2;
end
