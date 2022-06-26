function [fleet] = createShips(diff)
% Purpose: Creates a data array that will be used to track of sink status, ship
% type, ship zize, position (x and y), orientation, and damage (up to five slots)
% syntax: [fleet] = createShips(diff)
% Input variables:
%   diff: User selected difficulty
% Output variables:
%   fleet: Vector that stores data for the fleet ships

%
% Created by:           Dean Boerrigter
% Section #:            DB-06
% Created On:           23 Mar 21
% Last Modified On:     28 Mar 21
%
% By submitting this program with my name, I affirm that the creation and
% modifications of this program are primarily my own work.

% Comments: Fully functioning at this time. (28 Mar 21)
%------------------------------------------------------------------------

%Determine number of each type of ship
if diff == 1 % (shipArea = 11)
    numCarriers = 0;
    numBattleships = 1;
    numDestroyers = 1;
    numSubs = 0;
    numPTs = 2;
elseif diff == 2 % (shipArea = 17)
    numCarriers = 1;
    numBattleships = 1;
    numDestroyers = 1;
    numSubs = 1;
    numPTs = 1;
else %diff == 3 % (shipArea = 25)
    numCarriers = 1;
    numBattleships = 1;
    numDestroyers = 3;
    numSubs = 1;
    numPTs = 2;
end

%Total ships
totalShips = numCarriers + numBattleships + numDestroyers + numSubs + numPTs;

%Preallocate fleet vectors (sunk, shipType, shipSize, xPos1, yPos1, direc)
fleet = zeros(totalShips, 6);

%Assigning random orientation for all ships
for k = 1:totalShips
    fleet(k, 6) = randi([0,3]);
end

%Parsing variable
row = 1;

%Assigning values for carriers
while numCarriers > 0 
    %Reduce number of carriers by one
    numCarriers = numCarriers - 1;
    
    %Set ship type to 1 for a carrier
    fleet(row, 2) = 1;
    
    %Set ship size to 5 for a carrier
    fleet(row, 3) = 5;
    
    %Increase parsing variable by one
    row = row + 1;
end

%Assigning values for battleships
while numBattleships > 0 
    %Reduce number of battleships by one
    numBattleships = numBattleships - 1;
    
    %Set ship type to 2 for a battleship
    fleet(row, 2) = 2;
    
    %Set ship size to 4 for a battleship
    fleet(row, 3) = 4;
    
    %Increase parsing variable by one
    row = row + 1;
end

%Assigning values for destroyers
while numDestroyers > 0 
    %Reduce number of destroyers by one
    numDestroyers = numDestroyers - 1;
    
    %Set ship type to 3 for a destroyer
    fleet(row, 2) = 3;
    
    %Set ship size to 3 for a destroyer
    fleet(row, 3) = 3;
    
    %Increase parsing variable by one
    row = row + 1;
end

%Assigning values for submarines
while numSubs > 0 
    %Reduce number of submarines by one
    numSubs = numSubs - 1;
    
    %Set ship type to 4 for a submarine
    fleet(row, 2) = 4;
    
    %Set ship size to 3 for a submarine
    fleet(row, 3) = 3;
    
    %Increase parsing variable by one
    row = row + 1;
end

%Assigning values for PT boat
while numPTs > 0 
    %Reduce number of PT boats by one
    numPTs = numPTs - 1;
    
    %Set ship type to 5 for a PT boat
    fleet(row, 2) = 5;
    
    %Set ship size to 2 for a PT boat
    fleet(row, 3) = 2;
    
    %Increase parsing variable by one
    row = row + 1;
end
