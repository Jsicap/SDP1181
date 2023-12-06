% Author: Team Excellence ENGR 1181
clc
clear

[y, Fs] = audioread('Music/battleMusic.mp4');
battleSong = audioplayer(y, Fs);

% Holds a vector with three integers representing RGB values for the default color
DefaultBackgroundColor = [230, 230, 230];

informationOn = false;
playAgain = true;

while playAgain

    % Creates the home screen
    homeScreen = simpleGameEngine('FinishedGraphics/buckeyemonHome.png', 84, 84, 16, DefaultBackgroundColor);
    % | Home Screen
    % Creates an empty canvas for the background and the foreground
    homeBoardFG = ones(12, 12);
    homeBoardBG = ones(12, 12);
    
    % Booleans used to indicate which mode is chosen
    pvpMode = false;
    aiMode = false;
    
    % Adding components to the canvas
    % Title
    homeBoardFG(3, 2:11) = [6:11, 10, 12:14];
    homeBoardBG(3, 2:11) = [2, 2, 2, 2, 2, 2, 2, 3, 3, 3];
    
    % Select Game Mode Message
    homeBoardFG(6, 6:7) = [21, 22];

    % Instructions Button
    homeBoardFG(1, 12) = 23;
    
    % Button 1
    homeBoardFG(9, 5:8) = [17, 18, 17, 20];
    homeBoardBG(9, 4:9) = [5, 5, 5, 5, 5, 5];
    
    % Button 2
    homeBoardFG(11, 5:8) = [15, 16, 1, 19];
    homeBoardBG(11, 4:9) = [4, 4, 4, 4, 4, 4];
    
    % Displays the home screen
    drawScene(homeScreen, homeBoardBG, homeBoardFG);
    title("Welcome! You can click on the (i) button to enable instructions.")
    
    % Asks for mouse input until the user selects one of the two modes
    while ~(aiMode || pvpMode)
        [row, col] = getMouseInput(homeScreen);
    
        % Checks if the user clicks the information button
        if (row == 1) && (col == 12)
            % Toggles the information boolean
            informationOn = ~informationOn;
        end

        % Checks if the user clicks the PvP mode button
        if (row == 9) && (col >= 4 && col <= 9)
            pvpMode = true;
            break;
        % Checks if the user clicks the AI mode button
        elseif (row == 11) && (col >= 4 && col <= 9)
            aiMode = true;
            break
        end
        
    end
    
    % Closes the home screen
    close();
    
    % | Character Selection
    % Creates an empty canvas for the background and the foreground
    chooseCharacterBoardFG = ones(12, 12);
    chooseCharacterBoardBG = ones(12, 12);
    
    % Creates the character selection screen
    selectCharacterScreen = simpleGameEngine('FinishedGraphics/CharacterSprites.png', 84, 84, 16, DefaultBackgroundColor);
    
    % Adding components to the canvas
    % Adds the "P1 Choose Your Characters" message
    chooseCharacterBoardFG(3, 3:10) = [19, 11:17];
    chooseCharacterBoardBG(3, 3:10) = [10, 10, 10, 10, 10, 10, 10, 10];
    
    % Adds the character roster
    chooseCharacterBoardFG(7:9, 5:8) = [[6, 1, 1 7]; [1, 1, 1, 1]; [8, 1, 1, 9]];
    
    % Displays the character selection screen 
    drawScene(selectCharacterScreen, chooseCharacterBoardBG, chooseCharacterBoardFG);
    if informationOn
        title("Click on the mascot you would like to play as.");
    end
    
    % Initializes the player's character variable to 1
    % The player1 variable represents which character player1 is currently fighting as
    player1 = 1;
    % Sets the HP to 100
    player1HP = [100, 100];
    % Prepares an empty array for player1's moves
    player1Moves = [];
    % Prepares an empty array for player1's characters
    player1Character = [];
    % Prepares an empty array for player1's weaknesses
    player1Weakness = [];
    
    % Asks for mouse input until the user has selected 2 characters
    while (size(player1Character) < 2)
        
        % Gets the next ith index of the character array
        index = size(player1Character) + 1;

        % Reads the grid coordinate that the user clicks on
        [row, col] = getMouseInput(selectCharacterScreen);
        
        % Checks if the user clicks on Purdue Pete
        if row == 7 && col == 5
            chooseCharacterBoardBG(:, :) = 4;
            player1Character(index) = 21;
            player1Weakness(index) = 37;
        % Checks if the user clicks on Brutus
        elseif row == 7 && col == 8
            chooseCharacterBoardBG(:, :) = 2;
            player1Character(index) = 23;
            player1Weakness(index) = 31;
        % Checks if the user clicks on Fighting Irish
        elseif row == 9 && col == 5
            chooseCharacterBoardBG(:, :) = 3;
            player1Character(index) = 25;
            player1Weakness(index) = 37;
        % Checks if the user clicks on Xichigan
        elseif row == 9 && col == 8
            chooseCharacterBoardBG(:, :) = 5;
            player1Character(index) = 27;
            player1Weakness(index) = 33;
        end
        
        % A background animation for the character selected
        % Adds a unique character sprite as the background
        drawScene(selectCharacterScreen, chooseCharacterBoardBG, chooseCharacterBoardFG);
        % Waits for one second
        pause(1);
        chooseCharacterBoardBG(:, :) = 1;
        % Puts the background back to the default
        drawScene(selectCharacterScreen, chooseCharacterBoardBG, chooseCharacterBoardFG);

    end

    % Sets player1's moves
    player1Moves = setCharacterMoves(player1Character(1));
    
    % Closes the player selection window
    close();

    % Initializes the player's character variable to 1
    player2 = 1;
    % Sets the HP to 100
    player2HP = [100, 100];
    % Prepares an empty array for player2's moves
    player2Moves = [];
    % Prepares an empty array for player2's characters
    player2Character = [];
    % Prepares an empty array for player2's weaknesses
    player2Weakness = [];
    % Variable that holds information if the AI if able to switch
    player2Switch = true;
    
    % Checks if PvP Mode was selected
    if pvpMode
    
        % Cleans the canvas
        chooseCharacterBoardBG = ones(12, 12);
    
        % Adding components to the canvas
        % Adds the "P2 Choose Your Characters" message
        chooseCharacterBoardFG(3, 3:10) = [18, 11:17];
        chooseCharacterBoardBG(3, 3:10) = [10, 10, 10, 10, 10, 10, 10, 10];
    
        % Adds the character roster
        chooseCharacterBoardFG(7:9, 5:8) = [[6, 1, 1 7]; [1, 1, 1, 1]; [8, 1, 1, 9]];
        
        % Displays the available character to the user
        drawScene(selectCharacterScreen, chooseCharacterBoardBG, chooseCharacterBoardFG);

        % Checks if the information boolean is set to true
        if informationOn
            % Displays an information message alongside the screen
            title("Click on the mascot you would like to play as.");
        end
        
        % Asks for mouse input until the user has selected 2 characters
        while (size(player2Character) < 2)

            % Gets the next ith index of player2's character vector
            index = size(player2Character) + 1;

            % Reads the grid coordinate that the user clicks on
            [row, col] = getMouseInput(selectCharacterScreen);
            
            % Checks if the user clicks on Purdue Pete
            if row == 7 && col == 5
                chooseCharacterBoardBG(:, :) = 4;
                player2Character(index) = 31;
                player2Weakness(index) = 27;
            % Checks if the user clicks on Brutus
            elseif row == 7 && col == 8
                chooseCharacterBoardBG(:, :) = 2;
                player2Character(index) = 33;
                player2Weakness(index) = 21;
            % Checks if the user clicks on Fighting Irish
            elseif row == 9 && col == 5
                chooseCharacterBoardBG(:, :) = 3;
                player2Character(index) = 35;
                player2Weakness(index) = 27;
            % Checks if the user clicks on Xichigan
            elseif row == 9 && col == 8
                chooseCharacterBoardBG(:, :) = 5;
                player2Character(index) = 37;
                player2Weakness(index) = 23;
            end

            % Displays a unique background depending on the character selected
            drawScene(selectCharacterScreen, chooseCharacterBoardBG, chooseCharacterBoardFG);
            % Waits for 1 second
            pause(1)
            % Returns the background back to the default
            chooseCharacterBoardBG(:, :) = 1;
            drawScene(selectCharacterScreen, chooseCharacterBoardBG, chooseCharacterBoardFG);
        end
        
        % Closes the window
        close();

    % Checks if AI mode was selected
    elseif aiMode

        % Creates an array holding each character sprite ids
        characterIds = [31, 33, 35, 37];

        % Performs the following until the AI has 2 characters
        while (size(player2Character) < 2)
    
            % Gets the ith index of player2's character vector
            index = size(player2Character) + 1;

            % Randomly selects a character for the AI
            player2Character(index) = characterIds(randi(size(characterIds)));
        
            % Checking who the AI is weak against
            if player2Character(index) == 31
                player2Weakness(index) = 27;
                characterIds = characterIds(characterIds ~= 31);
            elseif player2Character(index) == 33
                player2Weakness(index) = 21;
                characterIds = characterIds(characterIds ~= 33);
            elseif player2Character(index) == 35    
                player2Weakness(index) = 27;
                characterIds = characterIds(characterIds ~= 35);
            elseif player2Character(index) == 37
                player2Weakness(index) = 23;
                characterIds = characterIds(characterIds ~= 37);
            end
            

        end
    end

    % Setting player2's moves
    player2Moves = setCharacterMoves(player2Character(1));
    
    % | Choosing first turn
    % Creates an empty canvas for the foreground and background
    selectingTurnBoardFG = ones(12, 12);
    selectingTurnBoardBG = ones(12, 12);
    
    % Creates the turn selection screen
    selectingTurnScene = simpleGameEngine("selectingTurn.png", 84, 84, 16, DefaultBackgroundColor);
    
    % Adding components to the turn selection screen
    % Adds the "Selecting First Turn" message
    selectingTurnBoardFG(3, 3:10) = [7:9, 1, 10:13];
    
    % Adding player avatars and loading dots
    selectingTurnBoardFG(6, 3:10) = [15, 3, 1, 1, 1, 14, 3, 1];
    
    % Displays the turn selection scene
    drawScene(selectingTurnScene, selectingTurnBoardBG, selectingTurnBoardFG);

    % Checks if the information boolean was clicked
    if informationOn
        % Displays a message alongside the window
        title("Wait one moment please...");
    end
    
    % Randomly decides who gets the first turn
    turn = randi(2);
        
    % Animates the three dots on the screen
    for i = 1:4
        % Shows 1 dot
        selectingTurnBoardFG(6, [5,10]) = [4, 4];
        pause(.01)
        drawScene(selectingTurnScene, selectingTurnBoardBG, selectingTurnBoardFG);
        % Shows 2 dots
        selectingTurnBoardFG(6, [5,10]) = [5, 5];
        pause(.01)
        drawScene(selectingTurnScene, selectingTurnBoardBG, selectingTurnBoardFG);
        % Shows 3 dots
        selectingTurnBoardFG(6, [5,10]) = [6, 6];
        pause(.01)
        drawScene(selectingTurnScene, selectingTurnBoardBG, selectingTurnBoardFG);
    end
    
    % Plays the battle music
    play(battleSong);

    % Checks if the information boolean is set to true
    if informationOn
        % Displays a message alongside the window
        title("Let's battle!");
    end
   
    % Checks if player1 gets the first turn
    if turn == 1
        spriteID = 15;
    % Checks if player2 gets the first turn
    elseif turn == 2 && pvpMode
        spriteID = 14;
    % Checks if the AI gets the first turn
    elseif turn == 2 && aiMode
        spriteID = 2;
    end
    
    % Shows a curtain-like animation before proceeding into the battle
    for col = 1 : (length(selectingTurnBoardFG(1, :))) / 2
        selectingTurnBoardFG(:, col) = spriteID;
        selectingTurnBoardFG(:, length(selectingTurnBoardFG(1, :)) + 1 - col) = spriteID;
        drawScene(selectingTurnScene, selectingTurnBoardBG, selectingTurnBoardFG);
        pause(0.0001)
    end
    
    % Closes the window
    close()
    
    % | Battle Screen
    % Creates an empty canvas for the new scene
    battleBoardFG = ones(12, 12);
    battleBoardBG = ones(12, 12);
    
    % Creates the battle screen
    battleScreen = simpleGameEngine("FinishedGraphics/BuckeyemonBattlePack.png", 70, 70, 16, [135, 206, 235]);
    
    % Adding components to the battle screen
    % Adds the grass
    battleBoardBG(5:12, :) = ones(8, 12) .* 29;
    % Adds the grass with white line
    battleBoardBG(6:3:12,:)= 30;
    
    % Adds the health bars for player 2 and 1 respectively
    if aiMode
        % "AI" HPbar
        battleBoardFG(2, 10:11) = [11,2];
    else
        % "P2" HPbar
        battleBoardFG(2, 10:11) = [10,2];
    end
    % "P1" HPbar
    battleBoardFG(11, 2:3) = [9,2];
    
    % Player 2's buckeyemon added
    battleBoardFG(5, 9) = player2Character(player2);
    
    % Player 1's buckeyemon added
    battleBoardFG(10, 4) = player1Character(player1);
     
    % Shows the battle scene
    drawScene(battleScreen, battleBoardBG, battleBoardFG);

    % Checks if the information boolean is set to true
    if informationOn
        % Shows a message alongside the window
        title("The green dot indicates who's turn it is.");
    end
    
    % Keeps the battle going as long as one of the players has a fighter alive
    while availableFighters(player1HP) >= 1 && availableFighters(player2HP) >= 1
        % Checks for which player's turn it is

        % Checks if it is player1's turn
        if turn == 1
            % Performs the following until player 1 makes a move
            while turn == 1

                % Removes asterick from player 2
                battleBoardFG(2, 12) = 1;

                % Adds player 1's moves
                battleBoardFG(11, 5:10) = player1Moves;

                % Removes player 2's moves
                battleBoardFG(2, 1:9) = 1;

                % Places asterisk by player 1
                 battleBoardFG(11, 1) = 49;

                 % Adds the switch button if player 1 has more than 1 character available
                 if availableFighters(player1HP) > 1
                     % Adds the switch button
                     battleBoardFG(11, 11) = 43;
                 else 
                     % Removes the switch button
                    battleBoardFG(11, 11) = 29;
                 end

                % Displays the battle scene
                drawScene(battleScreen, battleBoardBG, battleBoardFG);

                % Initializes damage to 0
                damage = 0;

                % Displays a message to the console
                fprintf("\n --- Player 1 --- \n");

                % Reads the mouse input from the user
                [row, col] = getMouseInput(battleScreen);

                % Checks if the one of the action buttons was clicked
                if row == 11 && (col == 5 || col == 7 || col == 9 || col == 11)

                    % Depending on the move chosen, the damage will be changed
                    switch(col)
                        case 5
                            % Button 1
                            % Normal Type moves always inflict the same damage
                            damage = 10;
                            
                            % Creates the diagonal fighting particles with
                            % normal fighting particles
                            FightParticles(player1Character(player1), col, 1, 1, battleScreen, battleBoardBG, battleBoardFG);
                            FightParticles(player1Character(player1), col, 1, 0, battleScreen, battleBoardBG, battleBoardFG);
                        case 7
                            % Button 2
                            % Special moves have to take the opponent's type into consideration
                            % Calls the attack function to make calculations
                            damage = attack(15, player1, player1Weakness, player1Character, player2, player2Weakness, player2Character);
                            % Creates diagonal fighting particles with
                            % character specific particles
                            FightParticles(player1Character(player1), col, 1, 1, battleScreen, battleBoardBG, battleBoardFG);
                            FightParticles(player1Character(player1), col, 1, 0, battleScreen, battleBoardBG, battleBoardFG);
                        case 9
                            % Button 3
                            % Special moves have to take the opponent's type into consideration
                            % Calls the attack function to make calculations
                            damage = attack(20, player1, player1Weakness, player1Character, player2, player2Weakness, player2Character);
                            % Creates diagonal fighting particles with
                            % character specific particles
                            FightParticles(player1Character(player1), col, 1, 1, battleScreen, battleBoardBG, battleBoardFG);
                            FightParticles(player1Character(player1), col, 1, 0, battleScreen, battleBoardBG, battleBoardFG);
                        case 11
                            fprintf("Character Switch!\n")
                            % Button 4
                            % The switch button allows users to switch their buckeyemon
                            player1 = switchCharacter(player1, player1HP);
                            % Updates the character sprite
                            battleBoardFG(10, 4) = player1Character(player1);
                            % Updates the character's moves
                            player1Moves = setCharacterMoves(player1Character(player1));
                            battleBoardFG(11, 5:10) = player1Moves;
                            % Updates the character's HP
                            battleBoardFG = updateHPBar(player1HP(player1), 1, battleBoardFG);
                    end
    
                    % Updates Player 2's HP (Damage takes effect)
                    player2HP(player2) = player2HP(player2) - damage;
                    % Updates the battle board's foreground to reflect the change in HP
                    battleBoardFG = updateHPBar(player2HP(player2), 2, battleBoardFG);

                    % Checks if player2's current character is unable to fight
                    if player2HP(player2) <= 0
                        % Displays a KO message to the console
                        fprintf("KO: Player 2's character is unable to fight - HP: %.2f \n", player2HP(player2));
                        % Switches player2's character to their next available fighter
                        player2 = switchCharacter(player2, player2HP);
                        % Updates the battle board
                        battleBoardFG(5, 9) = player2Character(player2);
                        % Updates player2's moves (player2's moves)
                        player2Moves = setCharacterMoves(player2Character(player2));
                        % Updates the battle board (player2's character sprite)
                        battleBoardFG(2, 4:9) = player2Moves;

                        % Updates the battle board (player2's HP bar)
                        battleBoardFG = updateHPBar(player2HP(player2), 2, battleBoardFG);
                    end
    
                    % Player 2 will get the next turn
                    turn = 2;
                end
            end
        % Player 2
        elseif turn == 2
            fprintf("\n --- Player 2 --- \n");

            % Removes asterisk from player 1
            battleBoardFG(11, 1) = 29;
            drawScene(battleScreen, battleBoardBG, battleBoardFG);
    
            % Add the asterisk to player 2
            battleBoardFG(2, 12) = 49;

            % Removes player 1's moves
            battleBoardFG(11, 5:11) = 29;

            % Shows the battle scene
            drawScene(battleScreen, battleBoardBG, battleBoardFG);

            % Checks if the AI is playing
            if aiMode

                % Waits for 2.5 seconds
                pause(2.5)

                % Sets the damage variable to 0
                damage = 0;

                % Checks if the AI has a strong character in their roster

                if strongerCharacterAvailable(player2Character, player2Weakness, player2, player1Character(player1), player1Weakness(player1)) && availableFighters(player2HP) > 1
                    
                    fprintf('Character Switch!\n');

                    player2 = switchCharacter(player2, player2HP);
                    battleBoardFG(5, 9) = player2Character(player2);

                    battleBoardFG = updateHPBar(player2HP(player2), 2, battleBoardFG);

                % Checks if the AI is strong against the opponent
                elseif player1Weakness(player1) == player2Character(player2)
                    % An array of moves (special moves)
                    attackDamage = [15, 20];
    
                    % Chooses one of the two moves randomly
                    damage = attack(attackDamage(randi(2)), player2, player2Weakness, player2Character, player1, player1Weakness, player1Character);

                    % Creates the diagonal fighting particles with
                    % normal fighting particles
                    FightParticles(player2Character(player2), col, 2, 1, battleScreen, battleBoardBG, battleBoardFG);
                    FightParticles(player2Character(player2), col, 2, 0, battleScreen, battleBoardBG, battleBoardFG);
 
                % Checks if the AI is weak against the opponent
                elseif player2Weakness(player2) == player1Character(player1)
                    fprintf("Normal | Damage: 10\n");

                    % Chooses the normal type move
                    damage = 10;

                    % Creates the diagonal fighting particles with
                    % normal fighting particles
                    FightParticles(player2Character(player2), col, 2, 1, battleScreen, battleBoardBG, battleBoardFG);
                    FightParticles(player2Character(player2), col, 2, 0, battleScreen, battleBoardBG, battleBoardFG);
 
                else
                    % An array of all the moves
                    attackDamage = [15, 20, 10];
   
                    % Chooses one of three moves randomly
                    damage = attack(attackDamage(randi(3)), player2, player2Weakness, player2Character, player1, player1Weakness, player1Character);

                    % Creates the diagonal fighting particles with
                    % normal fighting particles
                    FightParticles(player2Character(player2), col, 2, 1, battleScreen, battleBoardBG, battleBoardFG);
                    FightParticles(player2Character(player2), col, 2, 0, battleScreen, battleBoardBG, battleBoardFG);
                end

                % Toogles the player2Switch boolean
                player2Switch = ~player2Switch;
    
                % Updates Player 1's HP
                player1HP(player1) = player1HP(player1) - damage;
    
                % Updates the battle board's foreground to reflect the change in HP
                battleBoardFG = updateHPBar(player1HP(player1), 1, battleBoardFG);
    
                % Checks if player1's fighter is unable to fight
                if player1HP(player1) <= 0
                    % Displays a KO message to the console
                    fprintf("KO: Player 1's character is unable to fight - HP: %.2f\n", player1HP(player1));
                    % Switches player1's character
                    player1 = switchCharacter(player1, player1HP);
                    % Updates the battle board (player1's Character Sprite)
                    battleBoardFG(10, 4) = player1Character(player1);

                    % Updates player1's moves
                    player1Moves = setCharacterMoves(player1Character(player1));
                    % Updates the battle board (player1's moves)
                    battleBoardFG(2, 4:9) = player1Moves;

                    % Updates the battle board (player1's HP Bar)
                    battleBoardFG = updateHPBar(player1HP(player1), 1, battleBoardFG);
                end

                % Player 1 will get the next turn
                turn = 1;
            end
            % Checks if it is player 2's turn (PvP mode)
            while turn == 2 && pvpMode

                % Sets the damage to 0 initially
                damage = 0;

                % Adds player 2's moves
                battleBoardFG(2, 4:9) = player2Moves;

                % Only shows the switch character button when a second mascot is still alive.
                if availableFighters(player2HP) > 1
                    % Adds the switch button to the battle board
                    battleBoardFG(2, 2) = 43;
                else 
                    % Removes the switch button to the battle board
                    battleBoardFG(2, 2) = 1;
                end

                % Displays the battle scene
                drawScene(battleScreen,battleBoardBG, battleBoardFG);

                % Reads the grid coordinate where the user clicked
                [row, col] = getMouseInput(battleScreen);

                % Checks if one of the action buttons was clicked
                if row == 2 && (col == 2 || col == 4 || col == 6 || col == 8)
                    switch(col)
                        case 4
                            fprintf("Normal | Damage: 10\n");
                            % Button 1
                            % Normal Type moves always inflict the same damage
                            damage = 10;
                            % Creates the diagonal fighting particles with
                            % normal fighting particles
                            FightParticles(player2Character(player2), col, 2, 1, battleScreen, battleBoardBG, battleBoardFG);
                            FightParticles(player2Character(player2), col, 2, 0, battleScreen, battleBoardBG, battleBoardFG);
                        case 6
                            % Button 2
                            % Special moves have to take the opponent's type into consideration
                            % Calls the attack function to make calculations
                            damage = attack(15, player2, player2Weakness, player2Character, player1, player1Weakness, player1Character);
                            % Creates diagnol fighting particles with
                            % character specific particles
                            FightParticles(player2Character(player2), col, 2, 1, battleScreen, battleBoardBG, battleBoardFG);
                            FightParticles(player2Character(player2), col, 2, 0, battleScreen, battleBoardBG, battleBoardFG);
                        case 8
                            % Button 3
                            % Special moves have to take the opponent's type into consideration
                            % Calls the attack function to make calculations
                            damage = attack(20, player2, player2Weakness, player2Character, player1, player1Weakness, player1Character);
                            % Creates diagnol fighting particles with
                            % character specific particles
                            FightParticles(player2Character(player2), col, 2, 1, battleScreen, battleBoardBG, battleBoardFG);
                            FightParticles(player2Character(player2), col, 2, 0, battleScreen, battleBoardBG, battleBoardFG);
                        case 2
                            fprintf('Character Switch!\n');
                            % Button 4
                            % The switch button allows users to switch their fighter
                            player2 = switchCharacter(player2, player2HP);
                            % Updates the player's charcter sprite on the board
                            battleBoardFG(5, 9) = player2Character(player2);
                            % Updates the player's moves
                            player2Moves = setCharacterMoves(player2Character(player2));
                            % Updates the player's moves on the board
                            battleBoardFG(11, 5:10) = player2Moves;

                            % Updates the player's HP Bar on the board
                            battleBoardFG = updateHPBar(player2HP(player2), 2, battleBoardFG);
                    end
    
                    % Updates Player 1's HP
                    player1HP(player1) = player1HP(player1) - damage;
                    % Updates the battle board's foreground to reflect the change in HP
                    battleBoardFG = updateHPBar(player1HP(player1), 1, battleBoardFG);

                    % Checks if player 1's charater is unable to fight
                    if player1HP(player1) <= 0
                        fprintf("KO: Player 1's character is unable to fight - HP: %.2f\n", player1HP(player1));
                        % Switches player1's character to the next fighter
                        player1 = switchCharacter(player1, player1HP);
                        % Updates player1's character sprite
                        battleBoardFG(10, 4) = player1Character(player1);

                        % Updates player1's moves
                        player1Moves = setCharacterMoves(player1Character(player1));
                        % Updates player1's moves onto the board
                        battleBoardFG(2, 4:9) = player1Moves;

                        % Updates player1's HP Bar
                        battleBoardFG = updateHPBar(player1HP(player1), 1, battleBoardFG);
                    end
    
                    % Player 1 will get the next turn
                    turn = 1;
                end
            end
        end
    end
    
    % Stops the music from playing
    stop(battleSong);

    close()

    % | Victory Screen
    % Creating the Screen
    victoryScreen = simpleGameEngine('FinishedGraphics/VictoryScreenSprites.png', 84, 84, 16, DefaultBackgroundColor);

    % Creates an empty canvas
    victoryBoardFG=ones(12,12);
    victoryBoardBG=ones(12,12);

    %Add Play Again Button
    victoryBoardFG(10,4)=12;

    %Add Quit Button
    victoryBoardFG(10,9)=13;

    % Calculating Winner & their Buckeyemon
    % Checks if player 1's HP is less than or equal to 0
    if player1HP(player1)<=0
        victoryBoardFG(3,5:8)=[8,1,9:10];
        victoryBoardBG(3,5:8)=[1,1,1,1];
    % Checks if player 2's HP is less than or equal to 0
    else
        victoryBoardFG(3,5:8)=[7,1,9:10];
        victoryBoardBG(3,5:8)=[1,1,1,1];
    end

    if player2HP(player2)<=0 
        if player1Character(player1)==21
            victoryBoardFG(6,7)=14;
            [r,c] = audioread('Music/PurdueVictorySong.mp4');
            winnerMusic = audioplayer(r, c);
        elseif player1Character(player1)==23
            victoryBoardFG(6,7)=15;
            [r,c] = audioread('Music/OhioStateFightSong.mp4');
            winnerMusic = audioplayer(r, c);
        elseif player1Character(player1)==25
            victoryBoardFG(6,7)=18;
            [r,c] = audioread('Music/NorteDameVictorySong.mp4');
            winnerMusic = audioplayer(r, c);
        elseif player1Character(player1)==27
            victoryBoardFG(6,7)=17;
            [r,c] = audioread('Music/MichiganVictorySong.mp4');
            winnerMusic = audioplayer(r, c);
        end
    end

    if player1HP(player1)<=0
        if player2Character(player2)==31
            victoryBoardFG(6,7)=14;
            [r,c] = audioread('Music/PurdueVictorySong.mp4');
            winnerMusic = audioplayer(r, c);
        elseif player2Character(player2)==33
            victoryBoardFG(6,7)=15;
            [r,c] = audioread('Music/OhioStateFightSong.mp4');
            winnerMusic = audioplayer(r, c);
        elseif player2Character(player2)==35
            victoryBoardFG(6,7)=18;
            [r,c] = audioread('Music/NorteDameVictorySong.mp4');
            winnerMusic = audioplayer(r, c);
        elseif player2Character(player2)==37
            victoryBoardFG(6,7)=17;
            [r,c] = audioread('Music/MichiganVictorySong.mp4');
            winnerMusic = audioplayer(r, c);
        end
    end
    
    % Play's the winner's music
    play(winnerMusic);

    %Displays the Victory Screen
    drawScene(victoryScreen,victoryBoardBG,victoryBoardFG);

    %Asking for Mouse input
    while true
            [row, col] = getMouseInput(victoryScreen);

            if (row == 10) && (col == 4)
                playAgain = true;
                break;
            elseif (row == 10) && (col == 9)
                playAgain = false;
                break
            end
    
    end

    % Stops the winner's music
    stop(winnerMusic);
    % Closes the window
    close();
end

function damage = attack(baseDamage, attacker, attackerWeakness, attackerCharacter, opponent, opponentWeakness, opponentCharacter)
    % Creates a variable that keeps track of the damage
    damage = 0;

    % Checks if the opponent is weak against the attacker
    if opponentWeakness(opponent) == attackerCharacter(attacker)
        % Boosts the damage
        damage = baseDamage * 1.25;
        fprintf('Super Effective | Damage: %.2f\n', damage);
    elseif attackerWeakness(attacker) == opponentCharacter(opponent)
        % Decreases the damage
        damage = baseDamage * .75;
        fprintf('Weak | Damage: %.2f\n', damage);
    else
        % Uses the baseDamage
        damage = baseDamage;
        fprintf('Normal | Damage: %.2f\n', damage);
    end
end

function boardFG = updateHPBar(HP, playerNum, boardFG)
    % Creates variables for the HP bar locations
    row = 0;
    col = 0;

    % Updates the HP bar coordinates depending on the player
    switch(playerNum)
        case 1
            % Player 1's HP bar is in the bottem left
            row = 11;
            col = 3;
        case 2
            % Player 2's HP bar is in the top left
            row = 2;
            col = 11;
    end

    % Updates the foreground board to the appropriate sprite number in the sprite sheet.
    if HP > 95
        boardFG(row, col) = 2;
    elseif HP > 85
        boardFG(row, col) = 3;
    elseif HP > 75
        boardFG(row, col) = 4;
    elseif HP > 55
        boardFG(row, col) = 5;
    elseif HP > 35
        boardFG(row, col) = 6;
    elseif HP > 15
        boardFG(row, col) = 7;
    elseif HP >= 0
        boardFG(row, col) = 8;
    end
end

%function [] = setCharacterWeakness()

% setCharacterMoves() is a function that returns the an array of moves for
% a given character
function moves = setCharacterMoves(playerCharacter)
     % Checks if the character is Purdue Pete
     if playerCharacter == 21 || playerCharacter == 31
        moves = [16, 1, 17, 1, 18,  1];
     % Checks if the character is Brutus
     elseif playerCharacter == 23 || playerCharacter == 33
        moves = [16, 1, 12, 1, 13,  1];
     % Checks if the character is Fighting Irish
     elseif playerCharacter == 25 || playerCharacter == 35
        moves = [16, 1, 14, 1, 15,  1];
     % Checks if the character is Xichigan
     elseif playerCharacter == 27 || playerCharacter == 37
        moves = [16, 1, 19, 1, 20,  1];
    end
end

% switchCharacter() returns the index of the next available character (if
% any)
function index = switchCharacter(player, playerHP)
    switch(player)
        case 2
            % Check if the character at index 1 has HP > 0
            if playerHP(1) > 0
                % Returns the next character's index
                index = 1;
            else 
                % Returns the OG character's index
                index = player;
            end
        case 1
            % Check if the character at index 2 has HP > 0
            if playerHP(2) > 0
                % Returns the next character's index
                index = 2;
            else 
                % Returns the OG character's index
                index = player;
            end
    end
end

% availableFighters() is a function that returns the number of available
% fighters that a player has to their disposle
function count = availableFighters(playerHP)
    count = 0;

    % Checks each index of the playerHP vecotr
    for i=1:size(playerHP)+1
        % Checks if the player at index i is alive
        if playerHP(i) > 0
            % Increments the counter by 1
            count = count + 1;
        end
    end
end

% strongerCharacterAvailable() is a function that returns a boolean that indicates if there is a more optinal fighter in the roster to fight an opponent 
function bool = strongerCharacterAvailable(attackerFighters, attackerWeaknesses, attacker, opponentFighter, opponentWeakness)

    bool = false;

    % Checks if the current fighter is strong against the opponent
    if attackerFighters(attacker) == opponentWeakness
        % There is not stronger character available
        bool = false;
    % Checks if the current fighter is weak against the opponent
    elseif attackerWeaknesses(attacker) == opponentFighter 
        % There is a stronger character available
        bool = true;
    % Checks if the other character is the roster is better suited for the fight
    else
        switch(attacker)
            case 1
                newAttacker = 2;
                 % Checks if the current fighter is strong against the opponent
                if attackerFighters(newAttacker) == opponentWeakness
                    % There is not stronger character available
                    bool = true;
                % Checks if the current fighter is weak against the opponent
                elseif attackerWeaknesses(newAttacker) == opponentFighter 
                    % There is a stronger character available
                    bool = false;
                end
            case 2
                newAttacker = 1;
                 % Checks if the current fighter is strong against the opponent
                if attackerFighters(newAttacker) == opponentWeakness
                    % There is not stronger character available
                    bool = true;
                % Checks if the current fighter is weak against the opponent
                elseif attackerWeaknesses(newAttacker) == opponentFighter 
                    % There is a stronger character available
                    bool = false;
                end
        end
    end
end

% function for character specific diagnol figthing particles and shift of
% character
function [] = FightParticles(playerCharacter, col, playerNum, mode, scene, boardBG, boardFG)
     % Checks which player sprite to update to create action appearance
    if playerNum == 1
        % Updates the foreground board
        boardFG(10, 4) = playerCharacter + mode;

    elseif playerNum == 2
        % Updates the background board
        boardFG(5, 9) = playerCharacter + mode;

    end
    
    % Creates the character specific fighting particles
    if col==4 || col==5
        % normal fighting particles
        boardFG(9, 5) = 44;
        boardFG(8, 6) = 44;
        boardFG(7, 7) = 44;
        boardFG(6, 8) = 44;
        drawScene(scene, boardBG, boardFG);
        % Waits 
        pause(.25);
        % Covers the diagonal battle particles with
        % grass and grass line
        boardFG(7:8, 5:8) = 29;
        boardFG(6:3:9,:) = 30;
        drawScene(scene, boardBG, boardFG);
        pause(.25);
    else
        if playerCharacter == 21 || playerCharacter == 31
            % normal fighting particles
            boardFG(9, 5) = 45;
            boardFG(8, 6) = 45;
            boardFG(7, 7) = 45;
            boardFG(6, 8) = 45;
            drawScene(scene, boardBG, boardFG);
            % Waits for half a second
            pause(.25);
            % Covers the diagonal battle particles with
            % grass and grass line
            boardFG(7:8, 5:8) = 29;
            boardFG(6:3:9,:) = 30;
            drawScene(scene, boardBG, boardFG);
            pause(.25);
        elseif playerCharacter == 23 || playerCharacter == 33
            % normal fighting particles
            boardFG(9, 5) = 46;
            boardFG(8, 6) = 46;
            boardFG(7, 7) = 46;
            boardFG(6, 8) = 46;
            drawScene(scene, boardBG, boardFG);
            % Waits
            pause(.25);
            % Covers the diagonal battle particles with
            % grass and grass line
            boardFG(7:8, 5:8) = 29;
            boardFG(6:3:9,:) = 30;
            drawScene(scene, boardBG, boardFG);
            pause(.25);
        elseif playerCharacter == 25 || playerCharacter == 35
            % normal fighting particles
            boardFG(9, 5) = 47;
            boardFG(8, 6) = 47;
            boardFG(7, 7) = 47;
            boardFG(6, 8) = 47;
            drawScene(scene, boardBG, boardFG);
            % Waits
            pause(.25);
            % Covers the diagonal battle particles with
            % grass and grass line
            boardFG(7:8, 5:8) = 29;
            boardFG(6:3:9,:) = 30;
            drawScene(scene, boardBG, boardFG);
            pause(.25);
        elseif playerCharacter == 27 || playerCharacter == 37
            % normal fighting particles
            boardFG(9, 5) = 48;
            boardFG(8, 6) = 48;
            boardFG(7, 7) = 48;
            boardFG(6, 8) = 48;
            drawScene(scene, boardBG, boardFG);
            % Waits
            pause(.25);
            % Covers the diagonal battle particles with
            % grass and grass line
            boardFG(7:8, 5:8) = 29;
            boardFG(6:3:9,:) = 30;
            drawScene(scene, boardBG, boardFG);
            pause(.25);
        end
    end
end