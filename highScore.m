function highScore(diff, totalTurns)
% Purpose: Read, update, display, and store high score values
% syntax: highScore(direction, currentX, currentY)
% Input variables:
%   diff: Integer describing the current difficulty of the game
%   totalTurns: Integer describing how many player turns have been taken in the game
% Output variables: N/A
%

%
% Created by:           Dean Boerrigter
% Section #:            DB-06
% Created On:           01 May 21
% Last Modified On:     01 May 21
%
% By submitting this program with my name, I affirm that the creation and
% modifications of this program are primarily my own work.

% Comments: N/A
%------------------------------------------------------------------------

%Read highscore sheet
switch diff
    case 1 %Easy
        highscores = dlmread('easy_highscores.txt'); %<SM:READ>
        scoreMsg = 'Easy Highscores';
    case 2 %Normal
        highscores = dlmread('norm_highscores.txt');
        scoreMsg = 'Normal Highscores';
    case 3 %Hard
        highscores = dlmread('hard_highscores.txt');
        scoreMsg = 'Hard Highscores';
end

%Check if new highscore
if totalTurns < highscores(1,1)
    pos = 0;
else
    %Find where the current score goes on the highscore sheet
    pos = find(highscores(:,1) <= totalTurns);
    pos = pos(end);
end

%Check if the new score is at the end of the list
if pos == size(highscores,1)
    temp = [];
else %Position is not at the end
    %Preallocate temporary variable to store score beneath insertion value
    temp = zeros(size(highscores, 1) - pos, 16);
    
    %Temporarily store all data below the insertion value
    for k = 1:pos
        %Temporary array
        temp(k,:) = highscores(k + pos,:);
    end
end


%Prompt user for their name
name = input('Enter your name(15 character maximum):', 's');

%Verify
while isempty(name)
    %Prompt user for their name
    name = input('Input required:', 's');
end

%Convert to a double and ensure that all spaces have something in them
name = [double(name) ones(1,15)*32];

%Find the first filled value
col = find(name ~= 32);
col = col(1);

%Only keep the first 15 filled characters
name = name(col:col + 14);

%Rebuild the highscore sheet
highscores = [highscores((1:pos),:); totalTurns name; temp];

%Update the highscore data file
switch diff
    case 1 %Easy
        dlmwrite('easy_highscores.txt', highscores); %<SM:WRITE>
    case 2 %Normal
        dlmwrite('norm_highscores.txt', highscores);
    case 3 %Hard
        dlmwrite('hard_highscores.txt', highscores);
end

%Print header
fprintf('\t\t\t%s\n', scoreMsg)
fprintf('   Place   Name\t\t\t\tTotal Turns\n')
fprintf('-------------------------------------------\n')

%Parsing variable (Ensures that no error message shows for small scoreboards and limits the size of the scoreboard)
if size(highscores, 1) > 10
    scoreSize = 10;
else %k is the number of rows of highscores
    scoreSize = size(highscores, 1);
end

%Print top ten scores
for k = 1:scoreSize
    fprintf('   %3d     %15s\t\t%3d\n', k, char(highscores(k,2:16)), highscores(k,1))
end

