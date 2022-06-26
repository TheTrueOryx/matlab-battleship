function [remstr, complete] = currentShips(fltvec)
% Purpose: Builds astring that shows the type and number of each type of 
% ships are remaining remaining ships.  Also checks if the game is over.
% syntax: remstr = currentShips(fltvec)
% Input variables:
%   fltvec: The fleet vector of the fleet that is currently being displayed
% Output variables:
%   remstr: A string describing how many of each type and number of each type of ships are remaining
%   complte: Logical value determining if the game is over
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

%Begin the string
remstr = '';
complete = 1;

%Check how many of each type of ship is left (Checks that ship type matches and that it has not been sunk)
remCarriers = sum(fltvec(:,2) == 1 & fltvec(:,1) == 0);
remBattleships = sum(fltvec(:,2) == 2 & fltvec(:,1) == 0);
remDestroyers = sum(fltvec(:,2) == 3 & fltvec(:,1) == 0);
remSubmarines = sum(fltvec(:,2) == 4 & fltvec(:,1) == 0);
remPTBoats = sum(fltvec(:,2) == 5 & fltvec(:,1) == 0);

%Add the additional lines only if there are ships present
%Remaining carriers
if remCarriers ~= 0
   remstr = [remstr sprintf('   %d Aircraft Carriers Remaining (") Size: 1 by 5\n', remCarriers)]; %<SM:STRING>
end

%Remaining battleships
if remBattleships ~= 0
   remstr = [remstr sprintf('   %d Battleships Remaining (#) Size: 1 by 4\n', remBattleships)]; 
end

%Remaining destroyers
if remDestroyers ~= 0
   remstr = [remstr sprintf('   %d Destroyers Remaining ($) Size: 1 by 3\n', remDestroyers)]; 
end

%Remaining submarines
if remSubmarines ~= 0
   remstr = [remstr sprintf('   %d Submarines Remaining (%%) Size: 1 by 3\n', remSubmarines)]; 
end

%Remaining PT boats
if remPTBoats ~= 0
   remstr = [remstr sprintf('   %d PT Boats Remaining (&) Size: 1 by 2\n', remPTBoats)]; 
end

%Verify remstr
if isempty(remstr)
   remstr = '   No ships remaining.';
   complete = 0;
end

