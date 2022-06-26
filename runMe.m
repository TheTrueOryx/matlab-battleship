
%--------------------------------------------------------------------------
% Program Number: runMe
% Program Purpose: Main program for Battleship
% Created By: Dean Boerrigter
%
% Created On:           23 Mar 21
% Last Modified On:     01 May 21
%
% Credit to: N/A
% By submitting this program with my name, I affirm that the creation and
% modifications of this program are primarily my own work.

% Comments: Battleship is a player v. computer game, where the player and
% computer take turns firing shots at each other's fleets.  During a turn,
% a square is selected to shoot at Gameplay ends once one of the fleet has
% been sunk.  Ships are sunk when all parts of them have been hit.
%
% (28 Mar 21) Game is currently working, although not all features have been
% implemented yet.  I still need to update the AI, as the current program only
% chooses random squares.  Also, I am working on adding a message that will
% display when a ship is sunk.  Lastly, I will add a GUI to the program.
% If I have extra time, I would like to add a "save/continue function" and
% a local leaderboard.
%
% (01 May 21) Game has been completed.  The AI is working, infinite loops
% have been eliminated, the game displays what ships are remaining, when a
% ship has been sunk, and a highscore board that tracks local scores, along
% with the first 15 filled characters of a name.
%
%           - 17% of total size should be taken up by ships
%           - Largest ship size is 1 by 5
%           - 8 by 8 for easy, 10 by 10 for normal, 12 by 12 for hard
%           - 4 ships for easy (11 squares), 5 ships for normal (17
%           squares), 8 ships for hard (25 squares)
%           - Fleet vectors (sunk, shipType, shipSize, xPos, yPos)
%           - Orientations: (0-East, 1-North, 2-West, 3-South)
%           - Square "1-1" is top left corner, "10-10" is bottom right
%           - AI currently chooses random shots (28 Mar 21)
%           - Placement vector (y, x, damage) NOTE: X and Y values are
%           reversed in the damage vectors
%--------------------------------------------------------------------------

%Setting up workspace
clear;
close all;
rng('shuffle');
clc;

%User welcome
fprintf('Welcome to Battleship!\n\n')
fprintf('  In this game, two players take turns firing shots at each other''s ships.\n')
fprintf('  You will select a grid square to fire at during your turn.\n')
fprintf('  The goal is to hit and sink all of your opponent''s ships before they sink yours!\n')
fprintf('  Your current game will be played against a computer.\n\n')

%Select difficulty
diff = input('Enter the difficulty (1-Easy  2-Normal  3-Hard): ','s');
diff = str2double(diff);

%Validate
while isempty(diff) || isnan(diff) || mod(diff,1) ~= 0 || diff < 1 || diff > 3  %<SM:ROP> %<SM:BOP>
    diff = input('Please enter a 1, 2, or 3: ','s');
    diff = str2double(diff);
end

%Define board size (based on difficulty)
if diff == 1 %<SM:IF>
    diffMsg = 'Easy';
    boardSize = 8;
    shipsMsg = '1 Battleship, 1 Destroyer, and 2 PT Boats';
elseif diff == 2
    diffMsg = 'Normal';
    boardSize = 10;
    shipsMsg = '1 Aircraft Carrier, 1 Battleship, 1 Destroyer, 1 Submarine, and 1 PT Boat';
else %diff == 3
    diffMsg = 'Hard';
    boardSize = 12;
    shipsMsg = '1 Aircraft Carrier, 1 Battleship, 3 Destroyers, 1 Submarine, and 2 PT Boats';
end

%Selection message with delay timer
fprintf('\n  Difficulty:   %s\n  Board Size:\t%d by %d\n  Ships:\t\t%s\n\nPress any key to continue.', diffMsg, boardSize, boardSize, shipsMsg)
pause()

%Define boards (P1 and P2)
p1board = zeros(boardSize); %These two boards track ship locations
p2board = zeros(boardSize);
p1hits = char(zeros(boardSize)+45); %These boards track shots (misses/hits)
p2hits = char(zeros(boardSize)+45);

%Create ships (P1 and P2)
p1fleet = createShips(diff); %<SM:PDF_CALL> %<SM:PDF_PARAM> %<SM:PDF_RETURN>
p2fleet = createShips(diff);

%Place ships(P1 and P2)
[p1board, p1fleet, p1damage] = placeShips(p1board, p1fleet);
[p2board, p2fleet, p2damage] = placeShips(p2board, p2fleet);

%Variables tracking total number of AI's shots and current shooting pattern
totalTurns = 0; %Total number of shots taken
aiHits = 0; %Number of hits on the current ship
aiTurns = 0; %Number of AI turns since last hit
aiMode = 0; %Determines if the AI is looking for a ship or destroying a ship
direction = 0; %Direction of the AI's firing pattern
initialX = 0; %X Variable used for tracking where the AI first hit a ship
initialY = 0; %Y Variable used for tracking where the AI first hit a ship

%Variable to continue game while incomplete
complete = 0;

%WHILE all ships not sunk play game
while complete == 0 %<SM:WHILE>
    %User's turn (Player 1)
    %Determine remaining AI ships
    remaining = currentShips(p2fleet);
    
    %Display user hit vector
    displayBoard(p1hits, 1);
    fprintf('\n   %d Enemy Ships Remaining\n', sum(p2fleet(:,1) == 0)) %Number of ships remaining
    fprintf('   ----------------------------------------------\n')
    fprintf('%s\n', remaining) %Types of ships remaining
    
    %Variable to continue repeating square selection if invalid shot
    repeat = 1;
    
    %User Selects firing square
    while repeat == 1 %Check if square is occupied
        %Getting x value for a shot
        prompt = sprintf('  Enter an X value between 1 and %d: ', length(p1board));
        x = input(prompt,'s');
        x = str2double(x);
        
        %Verify
        while isempty(x) || isnan(x) || mod(x,1) ~= 0 || x < 1 || x > length(p1board) %<SM:NEST>
            prompt = sprintf('  Enter an X value between 1 and %d: ', length(p1board));
            x = input(prompt,'s');
            x = str2double(x);
        end
        
        %Getting y value for a shot
        prompt = sprintf('  Enter a Y value between 1 and %d: ', length(p1board));
        y = input(prompt,'s');
        y = str2double(y);
        
        %Verify
        while isempty(y) || isnan(y) || mod(y,1) ~= 0 || y < 1 || y > length(p1board)
            prompt = sprintf('  Enter a Y value between 1 and %d: ', length(p1board));
            y = input(prompt,'s');
            y = str2double(y);
        end
        
        %Check that the square has not been shot at
        if p1hits(y,x) ~= '-'
            fprintf('You have already shot at that square.\n')
            repeat = 1;
        else %Square was not previously shot at
            %Do not repeat loop
            repeat = 0;
            
        end
    end
    
    %User shoots
    user = 1;
    [p1hits, p2board, p2fleet, p2damage, status, ~] = shot(p1hits, p2board, p2fleet, p2damage, x, y, user); %<SM:PDF>
    
    %Redisplay user hit vector to show shot
    displayBoard(p1hits, 1);
    
    %Display status of the shot
    fprintf('%s\n', status) %Nicer formatting
    pause(2) %Allow user to see the action for 2 seconds
    
    
    %AI's turn (Player 2)
    %Determine remaining AI ships
    remaining = currentShips(p1fleet);
    
    %Display user board vector
    displayBoard(p1board, 0);
    fprintf('\n   %d Player Ships Remaining\n', sum(p1fleet(:,1) == 0)) %Number of ships remaining
    fprintf('   ----------------------------------------------\n')
    fprintf('%s\n', remaining) %Types of ships remaining
    pause(2) %Allow user to see the action for 2 seconds
    
    %Update aiTurns
    aiTurns = aiTurns + 1;
    
    %Select current shooting mode
    switch aiMode
        case 0 %Random mode
            %AI chooses a random location on a checkerboard pattern
            [x,y] = gridNum(p1board);
            
            %Variable to avoid infinite loops
            numReps = 0;
            
            %Verify
            while p2hits(y,x) ~= '-'
                %AI chooses a random location on a checkerboard pattern
                [x,y] = gridNum(p1board);
                
                %Check if in inifinite loop
                if numReps > numel(p1board)/2
                    %AI chooses a random location on a checkerboard pattern
                    [x,~] = gridNum(p1board);

                    %IF x is odd
                    if mod(x,2) ~= 0
                        %y should be even
                        y = randi([1,length(boardvec)/2])*2;
                    else %x is even
                        %y should be odd
                        y = randi([1,length(boardvec)/2])*2 - 1;
                    end
                end
                
                %Increase numReps
                numReps = numReps + 1;
                
            end
            
        case 1 %Destroy current ship
            %Repeated twice to avoid errors caused by corners
            for k = 1:2
                %Eliminate invalid directions based on current number (edges)
                if initialX == 1 && direction == 2
                    direction = direction + 1;
                elseif initialX == length(p1board) && direction == 0
                    direction = direction + 1;
                elseif initialY == 1 && direction == 1
                    direction = direction + 1;
                elseif initialY == length(p1board) && direction == 3
                    direction = 0;
                end
            end
            
            %Select x an y based on direction
            [x,y] = dirNum(direction, currentX, currentY);
            
            %Verify if already hit or at an edge
            while p2hits(y,x) ~= '-' || x == 0 || y == 0 || x > length(p1board) || y > length(p1board)
                %Try a new direction
                direction = direction + 1;
                
                %Ensure that direction is a valid number
                if direction >= 4
                    direction = direction - 4;
                end
                
                %Variable preventing infinite loops
                numReps = 0;
                
                %Select x an y based off of direction
                [x,y] = dirNum(direction, currentX, currentY);
                numReps = numReps + 1;
                
                %If stuck in an infinite loop, switch to search mode
                if numReps > 4
                    %AI chooses a random location on a checkerboard pattern
                    [x,y] = gridNum(p1board);
                    aiMode = 0;
                end
                
            end

    end %aiMode switch
    
    %AI shoots
    user = 0;
    [p2hits, p1board, p1fleet, p1damage, status, hitstatus] = shot(p2hits, p1board, p1fleet, p1damage, x, y, user); %<SM:RANDUSE>
    totalTurns = totalTurns + 1; %<SM:RTOTAL>  Total number of turns the ai and player have taken
    
    %Updates the aiTurns variable to reflect number of turns since last hit
    if hitstatus == 1
        aiTurns = 0;
        aiHits = aiHits + 1;
        
        %Remember the first coordinates to be hit
        if aiMode ~= 1
            initialX = x;
            initialY = y;
            currentX = x;
            currentY = y;
            direction = 0; %(0-East, 1-North, 2-West, 3-South)
        else %aiMode == 1, do not get a new initialX and Y
            %Update current location
            currentX = x;
            currentY = y;
        end
        
        %Change mode to destroy current ship
        aiMode = 1;
        
    elseif hitstatus == 2
        aiTurns = 0;
        aiMode = 0; %Change to seeking mode
        
    else %the last shot was a miss
        %Check the other direction (Initial hit was in middle of ship)
        if aiHits >= 2 && aiTurns > 2
            currentX = initialX;
            currentY = initialY;
            direction = direction + 2;
        else %Try a new direction
            direction = direction + 1;
        end
        
        %Ensure that direction is a valid number
        if direction >= 4
            direction = direction - 4;
        end
        
    end
    
    %Redisplay board to show AI's shot
    displayBoard(p1board, 0);
    
    %Redetermine remaining user ships
    remaining = currentShips(p2fleet);
    
    %Display status of the shot
    fprintf('%s\n', status) %Nicer formatting
    pause(2); %Allow user to see the action for 2 seconds
    
    %Check if either player has no ships left
    if sum(sum(p2board)) == 0 || sum(sum(p1board)) == 0
        %Set complete to true
        complete = 1;
    end

end

%Win/loss message
if sum(sum(p2board)) == 0
    fprintf('Congrats! You win!\n')
    
    %Let user read the screen
    pause(2);
    clc;
    
    %Update the high score data file and display highscores
    highScore(diff, totalTurns);
    
else %User Loses
    fprintf('You Lose\n')
end

