

%----------------------------------------------------------------------
%                       Setting up PTB
%----------------------------------------------------------------------

% Clear the workspace and the screen
sca;
close all;
clear all;
Screen('Preference', 'SkipSyncTests', 1);

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%----------------------------------------------------------------------
%                       Keyboard Presses
%----------------------------------------------------------------------

nextKey = KbName('RightArrow');
escapeKey= KbName('ESCAPE');
enterKey = KbName('ENTER')
nKey = KbName('n')

%----------------------------------------------------------------------
%                       Creating the Window
%----------------------------------------------------------------------

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', 0, [255 255 255], [0 0 1000 1000], screenNumber, black, [], 32, 2);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Query the frame duration
% ifi = Screen('GetFlipInterval', window);

%----------------------------------------------------------------------
%                       Instruction Slide
%----------------------------------------------------------------------
DrawFormattedText(window, ['Welcome to the RGB Anomaloscope! \n\n ' ...
    'Press any key to see instructions!'],...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;

DrawFormattedText(window, ['In this task, you will be given two squares. \n\n ' ...
    'Your job is to use the slider to make the box on the left be the same \n color as the box on the right \n\n ' ...
    'Once you have a match, press the right arrow key! \n\n ' ...
    'If a match is not possible, press the N key \n\n ' ...
    'Press the right arrow key TWICE to begin!'],...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;

%----------------------------------------------------------------------
%                       Creating Rectangles
%----------------------------------------------------------------------

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];
baseRect2 = [0 0 50 50];

% Screen X and Y positions of our three rectangles
squareXpos = [screenXpixels * 0.33 screenXpixels * 0.67];
squareYpos = [screenYpixels * 0.33 screenYpixels * 0.33];
numSqaures = length(squareXpos);

%----------------------------------------------------------------------
%                       Mouse Specifications
%----------------------------------------------------------------------
% Here we set the initial position of the mouse to be in the centre of the screen
SetMouse(screenXpixels * 0.33, screenYpixels * 0.66, window);

% We now set the squares initial position to the centre of the screen
sx = screenXpixels * 0.33;
sy = screenYpixels * 0.66;
centeredRect = CenterRectOnPointd(baseRect2, sx, sy);
offsetSet = 0;

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

%----------------------------------------------------------------------
%                             Trials!!
%----------------------------------------------------------------------

%Setting up loop to regenerate trials
trialNum = 0;
scoreTally = 0;

while trialNum < 5
    [keyIsDown,secs, keyCode] = KbCheck;
    %trialNum = trialNum + 1;
    if keyCode(escapeKey)
        ShowCursor;
        sca;
        return
    elseif keyCode(nextKey) || keyCode(nKey)
        WaitSecs(0.2);
        %Generate random Red and Green values
        r_given = randi([50,220],1)/255;
        r_given_exp = abs(r_given - randi([50,220],1)/255);
        g_given = randi([100,220],1)/255;
        g_check = g_given;
        g_given_exp = abs(g_given - randi([100,220],1)/255);
        
        %Create variable to randomize the trialType
            %trialType 1: r is changed, final squares can match
            %trialType 2: r is changed, final squaresn cannot match
            %trialType 3: g is changed, final squares can match
            %trialType 4: g is changed, final squares cannot match
        trialType = randi(4,1);
        
        % Make our rectangle coordinates
        allRects = nan(4, 3);
        for i = 1:numSqaures
            allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
        end

        % Flip to the screen
        Screen('Flip', window);

        while KbCheck == 0
            if trialType == 1 %slider should only change r_given_exp
                allColors = [r_given_exp r_given 0; g_given g_given 0; 0 0 1];
                % Draw the rect to the screen
                Screen('FillRect', window, allColors, allRects);
                % Get the current position of the mouse
                [mx, my, buttons] = GetMouse(window);
            
                % Find the central position of the square
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the square
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the square and a mouse button is being
                % pressed and the offset has not been set, set the offset and signal
                % that it has been set
                if inside == 1 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
                % If we are clicking on the square allow its position to be modified by
                % moving the mouse, correcting for the offset between the centre of the
                % square and the mouse position
            
                if inside == 1 
                    sx = mx - dx;
                    corrected_sx = 255*((sx-255)/(750-255));
                end

                if sx < 255
                    sx = 255;
                        
                end 
                
                if sx > 750
                    sx = 750;
                end
            
                r_given_exp = corrected_sx/255;
    
                disp(r_given_exp);

                % Draw a line behind the red rectangle to simulate a slider
                Screen('DrawLine', window, [0], 250, 660, 750, 660);
            
                % Center the rectangle on its new screen position
                centeredRect = CenterRectOnPointd(baseRect2, sx, sy);
            
                % Draw the rect to the screen
                Screen('FillRect', window, [1 0 0] , centeredRect);
            
                % Draw a white dot where the mouse cursor is
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
            
                % Check to see if the mouse button has been released and if so reset
                % the offset cue
                if sum(buttons) <= 0
                    offsetSet = 0;
                end
    
                %Flip to the screen
                Screen('Flip', window);

            elseif trialType == 2 %slider should only change r_given_exp
                allColors = [r_given_exp r_given 0; g_given_exp g_given 0; 0 0 1];
                
                % Draw the rect to the screen
                Screen('FillRect', window, allColors, allRects);
                % Get the current position of the mouse
                [mx, my, buttons] = GetMouse(window);
            
                % Find the central position of the square
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the square
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the square and a mouse button is being
                % pressed and the offset has not been set, set the offset and signal
                % that it has been set
                if inside == 1 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
                % If we are clicking on the square allow its position to be modified by
                % moving the mouse, correcting for the offset between the centre of the
                % square and the mouse position
            
                if inside == 1 
                    sx = mx - dx;
                    corrected_sx = 255*((sx-255)/(750-255));
                end

                if sx < 255
                        sx = 255;
                        
                end 
                
                if sx > 750
                    sx = 750;
                end
           
                r_given_exp = corrected_sx/255;
    
                disp(r_given_exp);

                % Draw a line behind the red rectangle to simulate a slider
                Screen('DrawLine', window, [0], 250, 660, 750, 660);
            
                % Center the rectangle on its new screen position
                centeredRect = CenterRectOnPointd(baseRect2, sx, sy);
            
                % Draw the rect to the screen
                Screen('FillRect', window, [1 0 0] , centeredRect);
            
                % Draw a white dot where the mouse cursor is
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
            
                % Check to see if the mouse button has been released and if so reset
                % the offset cue
                if sum(buttons) <= 0
                    offsetSet = 0;
                end
    
                %Flip to the screen
                Screen('Flip', window);
                
            elseif trialType == 3 %slider should only change g_given_exp
                allColors = [r_given r_given 0; g_given_exp g_given 0; 0 0 1];

                % Draw the rect to the screen
                Screen('FillRect', window, allColors, allRects);
                % Get the current position of the mouse
                [mx, my, buttons] = GetMouse(window);
            
                % Find the central position of the square
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the square
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the square and a mouse button is being
                % pressed and the offset has not been set, set the offset and signal
                % that it has been set
                if inside == 1 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
                % If we are clicking on the square allow its position to be modified by
                % moving the mouse, correcting for the offset between the centre of the
                % square and the mouse position
            
                 if inside == 1 
                    sx = mx - dx;
                    corrected_sx = 255*((sx-255)/(750-255));
                 end


                if sx < 255
                        sx = 255;
                        
                end 
                
                if sx > 750
                    sx = 750;
                end
           
                g_given_exp = corrected_sx/255;
    
                disp(g_given_exp);

                % Draw a line behind the red rectangle to simulate a slider
                Screen('DrawLine', window, [0], 250, 660, 750, 660);
            
                % Center the rectangle on its new screen position
                centeredRect = CenterRectOnPointd(baseRect2, sx, sy);
            
                % Draw the rect to the screen
                Screen('FillRect', window, [1 0 0] , centeredRect);
            
                % Draw a white dot where the mouse cursor is
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
            
                % Check to see if the mouse button has been released and if so reset
                % the offset cue
                if sum(buttons) <= 0
                    offsetSet = 0;
                end
    
                %Flip to the screen
                Screen('Flip', window);

            elseif trialType == 4 %slider should only change g_given_exp
                allColors = [r_given_exp r_given 0; g_given_exp g_given 0; 0 0 1];

                % Draw the rect to the screen
                Screen('FillRect', window, allColors, allRects);
                % Get the current position of the mouse
                [mx, my, buttons] = GetMouse(window);
            
                % Find the central position of the square
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the square
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the square and a mouse button is being
                % pressed and the offset has not been set, set the offset and signal
                % that it has been set
                if inside == 1 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
                % If we are clicking on the square allow its position to be modified by
                % moving the mouse, correcting for the offset between the centre of the
                % square and the mouse position
            
                if inside == 1 
                    sx = mx - dx;
                    corrected_sx = 255*((sx-255)/(750-255));
                end


                if sx < 255
                        sx = 255;
                        
                end 
                
                if sx > 750
                    sx = 750;
                end
           
            
                g_given_exp = corrected_sx/255;
    
                disp(g_given_exp);

                % Draw a line behind the red rectangle to simulate a slider
                Screen('DrawLine', window, [0], 250, 660, 750, 660);
            
                % Center the rectangle on its new screen position
                centeredRect = CenterRectOnPointd(baseRect2, sx, sy);
            
                % Draw the rect to the screen
                Screen('FillRect', window, [1 0 0] , centeredRect);
            
                % Draw a white dot where the mouse cursor is
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
            
                % Check to see if the mouse button has been released and if so reset
                % the offset cue
                if sum(buttons) <= 0
                    offsetSet = 0;
                end
    
                %Flip to the screen
                Screen('Flip', window);

            end

        end
        
        
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(nKey)
            if trialType == 2 || trialType == 4
                scoreTally = scoreTally + 1;
        
            elseif trialType == 1 || trialType == 3
                scoreTally = scoreTally + 0;
             
            end 
        elseif keyCode(nextKey)
            if trialType == 2 || trialType == 4
                scoreTally = 0;
            elseif trialType == 1 
                if abs(r_given - r_given_exp) <= 0.15
                    scoreTally = scoreTally + 1;
                else
                    scoreTally = scoreTally + 0;
                end 
            elseif trialType == 3
                if abs(g_given - g_given_exp) <= 0.15
                    scoreTally = scoreTally + 1;
                else 
                    scoreTally = scoreTally + 0;
                end 
            end 
        end 

        RGBscore = scoreTally/(trialNum + 1);

        %Move to the next trialj
        trialNum = trialNum+1;
    end

end

scoreDisp = num2str(RGBscore*100);
WaitSecs(0.2);
DrawFormattedText(window, [strcat('Your score is: ','  ', scoreDisp, '%. \n\n Press any key to continue.')],...
    'center', 'center', black);
Screen('Flip', window);

KbStrokeWait;

% Clear the screen
sca;