function [board, fleet, damage] = placeShips(boardvec, fltvec)
% Purpose: Modifies current fleet vector to place the ships in a
% non-conflicting manner on the board and creates a vector that tracks ship
% damage
% syntax: [fleet] = placeShips(diff)
% Input variables:
%   boardvec: VEtor that stores location data, determined in main program
%   fltvec: Current fleet vector
% Output variables:
%   fleet: Vector that stores setup data for the fleet ships
%   board: Vector that stores data for squares occupied by fleet ships
%   damage: Vector that stores damage data for all fleet ships

%
% Created by:           Dean Boerrigter
% Section #:            DB-06
% Created On:           23 Mar 21
% Last Modified On:     13 Apr 21
%
% By submitting this program with my name, I affirm that the creation and
% modifications of this program are primarily my own work.

% Comments: Fully functioning at this time. (28 Mar 21)
%
%           Damage is now stored in a cell vector. (13 Apr 21)
%
%           - Larger ships placed first to avoid spacing conflicts
%           - Fleet vectors (sunk, shipType, shipSize, xPos, yPos, direc)
%           - Orientations: (0-East, 1-North, 2-West, 3-South)
%           - Square "1-1" is top left corner, "10-10 is bottom right"
%           - Placement vector (y, x, damage) NOTE: X and Y values are
%           reversed in the damage vectors
%------------------------------------------------------------------------

%Preallocating ship damage tracker
damage = cell(1, size(fltvec, 1));

%FOR number of ships
for k = 1:size(fltvec, 1) %<SM:FOR> %<SM:REF>
    %Boolean to check if the ship has been placed
    placed = 0;
    
    %Repeat until ship is placed
    while placed == 0
        %Preallocating placement vector(xPos, yPos, damage)
        placement = zeros(fltvec(k,3),3);
        
        %Place by orientation of the ship
        if fltvec(k,6) == 0 %East
            %Random xPos and yPos variables such that ship does not cross
            %the border of the game board
            fltvec(k,4) = randi([1,fltvec(k,3) + 1]);
            fltvec(k,5) = randi([1,length(boardvec)]);
            
            %Temporary vector stores coordinates of possible placement (xPos, yPos)
            for pos = 1:fltvec(k,3) %FOR length of ship
                placement(pos, 2) = fltvec(k,4) + pos - 1; %xPos
                placement(pos, 1) = fltvec(k,5); %yPos
            end
            
        elseif fltvec(k,6) == 1 %North Orientation
            %Random xPos and yPos variables such that ship does not cross
            %the border of the game board
            fltvec(k,4) = randi([1,length(boardvec)]);
            fltvec(k,5) = randi([fltvec(k,3),length(boardvec)]);
            
            %Temporary vector stores coordinates of possible placement (xPos, yPos)
            for pos = 1:fltvec(k,3) %FOR length of ship
                placement(pos, 2) = fltvec(k,4); %xPos
                placement(pos, 1) = fltvec(k,5) - pos + 1; %yPos
            end
            
        elseif fltvec(k,6) == 2 %West Orientation
            %Random xPos and yPos variables such that ship does not cross
            %the border of the game board
            fltvec(k,4) = randi([fltvec(k,3),length(boardvec)]);
            fltvec(k,5) = randi([1,length(boardvec)]);
            
            %Temporary vector stores coordinates of possible placement (xPos, yPos)
            for pos = 1:fltvec(k,3) %FOR length of ship
                placement(pos, 2) = fltvec(k,4) - pos + 1; %xPos
                placement(pos, 1) = fltvec(k,5); %yPos
            end
            
        else %fltvec(k,6) == 3 %South Orientation
            %Random xPos and yPos variables such that ship does not cross
            %the border of the game board
            fltvec(k,4) = randi([1,length(boardvec)]);
            fltvec(k,5) = randi([1,fltvec(k,3) + 1]);
            
            %Temporary vector stores coordinates of possible placement (xPos, yPos)
            for pos = 1:fltvec(k,3) %FOR length of ship
                placement(pos, 2) = fltvec(k,4); %xPos
                placement(pos, 1) = fltvec(k,5) + pos - 1; %yPos
            end
            
        end
        
        %Variable to track if any squares are occupied
        occupied = 0;
        
        %FOR loop checking that each x and y pair is not occupied
        for row = 1:size(placement,1)
            if boardvec(placement(row,1), placement(row,2)) ~= 0
                occupied = 1;
            end %else do not update occupied
        end
        
        %IF all squares are not occupied, ship is placed
        if occupied == 0
            placed = 1;
            boardvec(placement(1,1),placement(1,2)) = fltvec(k,2)-12;
            boardvec(placement(2:end-1,1),placement(2:end-1,2)) = fltvec(k,2)-12; %<SM:SLICE>
            boardvec(placement(end,1),placement(end,2)) = fltvec(k,2)-12;           
            
        end %else ship is not placed
        
    end %WHILE loop continues while a ship is not placed
    
    %Ship has been placed, create the damage vector for the ship
    damage{k} = placement;
    
end %FOR loop iterating for number of ships

%Return the updated vectors by renaming the variables
board = boardvec;
fleet = fltvec;
