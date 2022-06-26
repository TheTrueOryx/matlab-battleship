function displayBoard(dispvec, type)
% Purpose: Determines if the shot is a hit or a miss.  Also updates the
% shot tracker and board if needed.
% syntax: diplayBoard(dispvec, user)
% Input variables:
%   dispvec: vector to be displayed
%   type: logical variable determining if this is a hit vector(1) or a board vector(0)
% Output variables: N/A
%  

%
% Created by:           Dean Boerrigter
% Section #:            DB-06
% Created On:           13 Apr 21
% Last Modified On:     13 Apr 21
%
% By submitting this program with my name, I affirm that the creation and
% modifications of this program are primarily my own work.

% Comments: - Ensure that inputs are correctly matched (user == 1 when a hit vector and user == 0 when it is a board vector)
%------------------------------------------------------------------------

%Determine header text
if type == 1 %This is a hit vector
    headMsg = 'Shots Taken';
else %This is a board vector
    headMsg = 'Your Fleet';
end

%Clear the screen
clc;

%Header
fprintf('           %s\n', headMsg)

%Spacing for the header
fprintf('     X')

%Generate the header
for col = 1:length(dispvec)
    fprintf('  %2d', col) %print current value
end

%Print the line
fprintf('\n  Y    ')
for k = 1:length(dispvec)
    fprintf('----');
end

%Spacing for the header
fprintf('\n')

%FOR all rows of dispvec
for row = 1:length(dispvec)
    fprintf(' %2d  |', row)
    
    %Display columns, using chars if it is a board vector
    if type == 1
        %FOR all columns of dispvec (hit vector)
        for col = 1:length(dispvec)
            fprintf('  %2s', dispvec(row,col)) %print current value
        end
    else %user == 0
        %FOR all columns of dispvec (board vector)
        for col = 1:length(dispvec)
            fprintf('  %2s', char(dispvec(row,col)+45)) %print current value
        end
    end
        
    %Go to next row    
    fprintf('\n')
end
