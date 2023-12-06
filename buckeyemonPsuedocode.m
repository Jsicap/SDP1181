% Author: Julio Sica-Perez

% Clear the workspacee
% Clear the command line

% | Create the object for the homescreen
% Create a 12 by 12 grid layout
% Add components to the home screen
    % Title
    % Button for PvP mode
    % Button for AI mode
% Display the home screen to the user
% Ask for mouse input until the user clicks on one of the two available buttons

% When the user clicks on one of the buttons modify the mode variable

% >>> Transition to the character selection screen

% | Character selection screen
% Create a 12 by 12 grid layout
% Add components to the character selection screen
    % Title
    % Roster of characters
% Display the character selection screen to the user
% Ask for mouse input until the user clicks on a character sprite

% When the user clicks on one of the sprites, modify the player variable
% Show a little animation

% If PvP mode was selected then show the character selections screen again
    % Update the player's selected character upon selection
% Else if AI mode was selected then randomly select a character for the AI

% >>> Transition to the loading screen

% Create a 12 by 12 grid layout
% Add components to the loading screen
    % Title
    % Player Avatars
    % Loading dots
% Animate the loading dots for four seconds

% >>> Transition to the battle screen

% | Battle screen
% Create a 12 by 12 grid layout
% Add components to the battle screen
    % HP Bars
    % Background color is blue
    % Grass for the background
    % Fighting characters
    % Player moves
% Display the battle scene

