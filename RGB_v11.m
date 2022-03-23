
%----------------------------------------------------------------------

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

% program variables for key names used in the RGB test
%right arrow for match trials,n for nonmatch, escape to exit the task
nextKey = KbName('RightArrow');
escapeKey= KbName('ESCAPE');
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
%thinner rectangle with a longer length to represent the slider
baseRect2 = [0 0 495 50];

% Screen X and Y positions of our three rectangles
squareXpos = [screenXpixels * 0.33 screenXpixels * 0.67];
squareYpos = [screenYpixels * 0.33 screenYpixels * 0.33];
numSqaures = length(squareXpos); 

%----------------------------------------------------------------------
%                       Mouse Specifications
%----------------------------------------------------------------------
% Here we set the initial position of the mouse to be in the center of the
% slider
SetMouse(screenXpixels * 0.33, screenYpixels * 0.66, window);

% We now set the 2 squares' positions to be centered on-screen
sx = screenXpixels * 0.33;
sy = screenYpixels * 0.66;
%slider is 2/3 the way down the y-axis, center on the x-axis
centeredRect = CenterRectOnPointd(baseRect2, xCenter, sy);
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

%12 trials, can move between them with a key press
while trialNum < 12
    [keyIsDown,secs, keyCode] = KbCheck;
    if keyCode(escapeKey)
        ShowCursor;
        sca;
        return
        %if the nonmatch (n) or match (right arrow) key pressed, progress
        %to next trial
    elseif keyCode(nextKey) || keyCode(nKey)
        WaitSecs(0.2);
        %Generate random Red and Green values between 50 and 220 on RGB

        r_given = randi([50,220],1)/255;
        %set r_given_exp to be at least 50 units away from r_given on RGB scale, to prevent the 2 initial colors being too similar
        r_given_exp = abs(r_given - randi([50,220],1)/255);
        g_given = randi([100,220],1)/255;
        g_check = g_given;
        %set g_given_exp to be at least 50 units away from g_given on RGB scale, to prevent the 2 initial colors being too similar
        g_given_exp = abs(g_given - randi([100,220],1)/255);
         
        %Create variable to randomize the trialType
            %trialType 1: red channel value is changed by slider, final squares can match
            %trialType 2: red channel value is changed by slider, final squares cannot match
            %trialType 3: green channel value is changed by sider, final squares can match
            %trialType 4: green channel value is changed by slider, final squares cannot match
        trialType = randi(4,1);
        
        % Make our rectangle coordinates
        allRects = nan(4, 3);
        for i = 1:numSqaures
            allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
        end

        % Flip to the screen
        Screen('Flip', window);

        %while a key is not being pressed, slider should still be active
        while KbCheck == 0
            if trialType == 1 %slider should only change r_given_exp
                allColors = [r_given_exp r_given 0; g_given g_given 0; 0 0 1];
                % Draw the rect to the screen
                Screen('FillRect', window, allColors, allRects);
                % Get the current position of the mouse
                [mx, my, buttons] = GetMouse(window);
            
                % Find the central position of the slider box
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the slider box
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the slider box and a mouse button is being pressed and the offset has not been set, set the offset and signal that it has been set
                if inside == 1 && sum(buttons) > 0 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
                % If we are inside the slider box and the cursor is pressed down, the value of mouse position is recorded
                

              % if the mouse is to the left of the slider box, lock the mouse position at the lowest possible x-value in the box 
                 if mx < 255
                        mx = 255;
                        
                end 
              % if the mouse is to the right of the slider box, lock the mouse position at the highest possible x-value in the box 
                if mx > 750
                    mx = 750;
                end
              % if mouse pressed down, convert the mouse value to the red channel value of the left square
              
                if inside == 1 && sum(buttons) > 0
                   
              % r_given_exp uses values between 0.0 and 1.0, mouse value mx is manipulated in order to mx = 255 to be linked to r_given_exp = 0; and mx = 750 linked to r_given_exp = 1.0  
                r_given_exp = (mx-255)/(750-5-255);
                end
 
    
                disp(r_given_exp);
            
                % Draw the rect to the screen
                   gray = GrayIndex(window,0.3);
                       Screen('FillRect', window, gray, centeredRect);
            
                % Draw a white dot where the mouse cursor is
                if sum(buttons) > 0
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
                end
            
                % Check to see if the mouse button has been released and if
                % so reset the offset cue, stop changing the red channel
                % value
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
            
                % Find the central position of the slider box
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the slider box
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the slider box and a mouse button is being
                % pressed and the offset has not been set, set the offset and signal
                % that it has been set
                if inside == 1 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
              % If we are inside the slider box and the cursor is pressed down, the value of mouse position is recorded
                

              % if the mouse is to the left of the slider box, lock the mouse position at the lowest possible x-value in the box 
                if mx < 255
                        mx = 255;
                        
                end 
                % if the mouse is to the right of the slider box, lock the mouse position at the highest possible x-value in the box 
                if mx > 750
                    mx = 750;
                end
                % if mouse pressed down, convert the mouse value to the red channel value of the left square
                if inside == 1 && sum(buttons) > 0
                   
                % r_given_exp uses values between 0.0 and 1.0, mouse value mx is manipulated in order to mx = 255 to be linked to r_given_exp = 0; and mx = 750 linked to r_given_exp = 1.0 
                r_given_exp = (mx-255)/(750-5-255);
                end

    
                disp(r_given_exp);
            
                % Draw the rect to the screen
                       gray = GrayIndex(window,0.3);
                       Screen('FillRect', window, gray, centeredRect);
            
                % Draw a white dot where the mouse cursor is
                if sum(buttons) > 0
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
                end
            
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
            
                % Find the central position of the slider box
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the slider box
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the slider box and a mouse button is being
                % pressed and the offset has not been set, set the offset and signal
                % that it has been set
                if inside == 1 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
               % If we are inside the slider box and the cursor is pressed down, the value of mouse position is recorded
                

              % if the mouse is to the left of the slider box, lock the mouse position at the lowest possible x-value in the box 
            
                if mx < 255
                        mx = 255;
                        
                end 
                % if the mouse is to the right of the slider box, lock the mouse position at the highest possible x-value in the box 
                if mx > 750
                    mx = 750;
                end
                % if mouse pressed down, convert the mouse value to the green channel value of the left square
                if inside == 1 && sum(buttons) > 0
                   
                  % g_given_exp uses values between 0.0 and 1.0, mouse value mx is manipulated in order to mx = 255 to be linked to g_given_exp = 0; and mx = 750 linked to g_given_exp = 1.0  
                g_given_exp = (mx-255)/(750-5-255);
                end

    
                disp(g_given_exp);
            
                % Draw the rect to the screen
                gray = GrayIndex(window,0.3);
                       Screen('FillRect', window, gray, centeredRect);
            
                % Draw a white dot where the mouse cursor is
                if sum(buttons) > 0
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
                end
            
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
            
                % Find the central position of the slider box
                [cx, cy] = RectCenter(centeredRect);
            
                % See if the mouse cursor is inside the slider box
                inside = IsInRect(mx, my, centeredRect);
            
                % If the mouse cursor is inside the slider box and a mouse button is being
                % pressed and the offset has not been set, set the offset and signal
                % that it has been set
                if inside == 1 && offsetSet == 0
                    dx = mx - cx;
                    dy = my - cy;
                    offsetSet = 1;
                end
            
                % If we are inside the slider box and the cursor is pressed down, the value of mouse position is recorded
                

                % if the mouse is to the left of the slider box, lock the mouse position at the lowest possible x-value in the box 
            
                if mx < 255
                        mx = 255;
                        
                end 
                % if the mouse is to the right of the slider box, lock the mouse position at the highest possible x-value in the box 
                if mx > 750
                    mx = 750;
                end
                % if mouse pressed down, convert the mouse value to the green channel value of the left square
                if inside == 1 && sum(buttons) > 0
                   
                % g_given_exp uses values between 0.0 and 1.0, mouse value mx is manipulated in order to mx = 255 to be linked to g_given_exp = 0; and mx = 750 linked to g_given_exp = 1.0 
                g_given_exp = (mx-255)/((750-5)-255);
                end

    
                disp(g_given_exp);
            
                % Draw the rect to the screen
                      gray = GrayIndex(window,0.3);
                       Screen('FillRect', window, gray, centeredRect);
            
                % Draw a white dot where the mouse cursor is
                if sum(buttons) > 0
                Screen('DrawDots', window, [mx my], 10, white, [], 2);
                end
            
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
        % if nonmatch trial types (2 and 4) are presented and the n key is
        % pressed, the answer is correct and scoreTally in increased by 1
        if keyCode(nKey)
            if trialType == 2 || trialType == 4
                scoreTally = scoreTally + 1;
        % if match trial types (1 and 3) are presented and the n key is
        % pressed, the answer is incorrect and scoreTally remains the same
            elseif trialType == 1 || trialType == 3
                scoreTally = scoreTally + 0;
             
            end 
        % if nonmatch trial types (2 and 4) are presented and the right
        % arrow key is pressed, the answer is incorrect and scoreTally remains the same
        elseif keyCode(nextKey)
            if trialType == 2 || trialType == 4
                scoreTally = 0;
        % if the red channel match trial type (1) is used, and the user
        % sets the experimental red channel value to within 5% of the given
        % red channel value and presses the right arrow, the answer is
        % correct and scoreTally is increased by 1
            elseif trialType == 1 
                if abs(r_given - r_given_exp) <= 0.05
                    scoreTally = scoreTally + 1;
                    % if the difference in red channel values is greater
                    % than 5%, scoreTally remains the same (even if right
                    % arrow pressed)
                else
                    scoreTally = scoreTally + 0;
                end 
        %if the green channel match trial type (1) is used, and the user
        % sets the experimental green channel value to within 5% of the given
        % green channel value and presses the right arrow, the answer is
        % correct and scoreTally is increased by 1
            elseif trialType == 3
                if abs(g_given - g_given_exp) <= 0.05
                    scoreTally = scoreTally + 1;
                    % if the difference in green channel values is greater
                    % than 5%, scoreTally remains the same (even if right
                    % arrow pressed)
                else 
                    scoreTally = scoreTally + 0;
                end 
            end 
        end 

        % calculate a percent correct (decimal form) by dividing the scoreTally by the
        % number of trials (plus 1 included because the trial number for
        % the last trial is set to trialNum + 1
        RGBscore = scoreTally/(trialNum + 1);

        %Move to the next trialj
        trialNum = trialNum+1;
    end

end

% change RGBscore into a percent and convert to a string, so it can be concatenated 
scoreDisp = num2str(RGBscore*100);
WaitSecs(0.2);
%ending screen with percent correct
DrawFormattedText(window, [strcat('Your score is: ','  ', scoreDisp, '%. \n\n Press any key to continue.')],...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait

% if the anomaloscope score is below 25%, direct user to the 1st level of
% the stroop test
if RGBscore < 0.25
    DrawFormattedText(window, 'You might be color blind! \n\n Just kidding lol we are not medical professionals \n\n ',...
    'center', 'center', black);
    Screen('Flip', window);
    KbStrokeWait;
    DrawFormattedText(window, 'You will now be continuing on to STROOP TEST LEVEL 1 \n\n Press any key to continue',...
    'center', 'center', black);
    Screen('Flip', window);
% if the anomaloscope score is between 25% and 50%, direct user to the 2nd level of
% the stroop test
elseif RGBscore >= 0.25 && RGBscore < 0.50
    DrawFormattedText(window, 'You will now be continuing on to STROOP TEST LEVEL 2 \n\n Press any key to continue',...
    'center', 'center', black);
    Screen('Flip', window);
% if the anomaloscope score is between 50% and 75%, direct user to the 3rd level of
% the stroop test
elseif RGBscore >= 0.50 && RGBscore < 0.75
    DrawFormattedText(window, 'You will now be continuing on to STROOP TEST LEVEL 3 \n\n Press any key to continue',...
    'center', 'center', black);
    Screen('Flip', window);
else 
% if the anomaloscope score is above 75%, direct user to the 4th level of
% the stroop test
    DrawFormattedText(window, 'You will now be continuing on to STROOP TEST LEVEL 4 \n\n Press any key to continue',...
    'center', 'center', black);
    Screen('Flip', window);
end 

KbStrokeWait;
% Clear the screen
sca;