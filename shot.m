function [hits, board, fleet, damage, status, hitstatus] = shot(hitvec, boardvec, fltvec, damagevec, x, y, user)
% Purpose: Determines if the shot is a hit or a miss.  Also updates the
% shot tracker and board if needed.
% syntax: [hits, board, fleet, damage, status, hitstatus] = shot(hitvec, boardvec, fltvec, damagevec, x, y, user)
% Input variables:
%   hitvec: Vector that stores previous shot data for each player
%   boardvec: Vector that stores data for squares occupied by fleet ships
%   fltvec: Current fleet vector
%   damagevec: Vector that tracks the damage of each ship in current fleet
%   x: x location of the shot
%   y: y location of the shot
%   user: logical variable determining if this is the user(1) or AI(0) shooting
% Output variables:
%   hits: Vector that stores previous shot data for each player
%   board: Vector that stores data for squares occupied by fleet ships
%   fleet: Updated fleet vector
%   damage: Updated damage vector
%   status: Output message based on the outcome of each shot
%   hitstatus: Logical value used by the ai

%
% Created by:           Dean Boerrigter
% Section #:            DB-06
% Created On:           28 Mar 21
% Last Modified On:     28 Apr 21
%
% By submitting this program with my name, I affirm that the creation and
% modifications of this program are primarily my own work.

% Comments: Does not currently update damage vector or generate a massage
% once a ship has been sunk. (28 Mar 21)
%
%           - Fleet vectors (sunk, shipType, shipSize, xPos, yPos, direc)
%           - x == damagevec(ship, 1:fltvec(ship,3))
%           - y == damagevec(ship, fltvec(ship,3)+1:fltvec(ship,3)*2)
%           - d == damagevec(ship, fltvec(ship,3)*2+1:fltvec(ship,3)*3)
%------------------------------------------------------------------------

%Hit condition
hit = 0;

%Hit detector
if boardvec(y,x) ~= 0 %Hit
    boardvec(y,x) = 0; %Remove object from square
    hitvec(y,x) = 'X';
    hit = 1;
    
    %Determines what ship was hit and stores the damage to that ship's square
    
    %Check data for each ship
    for nShips = 1:numel(damagevec)
        %Check each row on the board for that ship
        for row = 1:size(damagevec{nShips},1)
            %If x and y values match (for the shot and the ship's square)
            if damagevec{nShips}(row,2) == x && damagevec{nShips}(row,1) == y %<SM:SEARCH>
                damagevec{nShips}(row,3) = 1; %Update the damage vector
                
                %Is a ship sunk?
                if damagevec{nShips}(:,3) == 1
                    %Update hit to show that the ship has been sunk
                    hit = 2;
                    
                    %Determine type of ship sunk
                    if fltvec(nShips, 2) == 1
                        shipType = 'an Aircraft Carrier';
                    elseif fltvec(nShips, 2) == 2
                        shipType = 'a Battleship';
                    elseif fltvec(nShips, 2) == 3
                        shipType = 'a Destroyer';
                    elseif fltvec(nShips, 2) == 4
                        shipType = 'a Submarine';
                    else %fltvec(nShips, 2) == 5
                        shipType = 'a PT Boat';
                    end
                    
                    %Add an addition to the status message
                    status = sprintf('\n\tX-Y: %d-%d\tHIT! You sunk %s!\n', x, y, shipType); %<SM:STRING>
                    
                    %Update the fltvec to show the ship is sunk
                    fltvec(nShips,1) = 1;
                    
                else %Ship was hit, bu not sunk
                    %Status message
                    status = sprintf('\n\tX-Y: %d-%d\tHIT!\n',x,y);
                    
                end %IF a ship was sunk
            end %IF hit coordinates and square coordinates match
        end % FOR each row
    end %FOR each ship
    
    
    
else %Miss
    hitvec(y,x) = 'O';
    
    %Status message
    status = sprintf('\n\tX-Y: %d-%d\tMISS\n',x,y);
end

%If this is the AI's shot, also update the player's board to show the AI's shots
if user == 0
    if hit == 1 || hit == 2 %Hit
        boardvec(y,x) = 43;
    else %Miss
        boardvec(y,x) = 34;
    end
end

%Update vectors
hits = hitvec;
board = boardvec;
fleet = fltvec;
damage = damagevec;
hitstatus = hit;

%Allow user to see the action for 2 seconds
pause(2)
