%RGB_v5 Roshan's Workspace

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

%----------------------------------------------------------------------
%                       Creating Rectangles
%----------------------------------------------------------------------

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', 0, [255 255 255], [0 0 1000 1000], screenNumber, black, [], 32, 2);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];
baseRect2 = [0 0 50 50];

% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.33 screenXpixels * 0.67];
squareYpos = [screenYpixels * 0.33 screenYpixels * 0.33];
numSqaures = length(squareXpos);

%Generate random Red and Green values
        r_given = randi([50,220],1)/255;
        r_given_exp = randi([50,220],1)/255;
        g_given = randi([100,220],1)/255;
        red = [1 0 0];
        % Here we set the initial position of the mouse to be in the centre of the
% screen
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

        % Set the colors to Red, Green and Blue
        allColors = [r_given_exp g_given 0; r_given g_given 0; 0 0 1];
        
        % Make our rectangle coordinates
        allRects = nan(4, 3);
        for i = 1:numSqaures
            allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
        end
        
        % Draw the rect to the screen
        Screen('FillRect', window, allColors, allRects);
       
% Flip to the screen
        Screen('Flip', window);

%Setting up loop to regenerate trials
trialNum = 0
while trialNum < 5
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
        corrected_sx = sx/4;
   end

   for corrected_sx = 1:255
       r_given_exp = corrected_sx
   end
   disp(r_given_exp);
 



           % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        

    % Center the rectangle on its new screen position
    centeredRect = CenterRectOnPointd(baseRect2, sx, sy);

    % Draw the rect to the screen
    Screen('FillRect', window, red, centeredRect);

    % Draw a white dot where the mouse cursor is
    Screen('DrawDots', window, [mx my], 10, white, [], 2);

    % Check to see if the mouse button has been released and if so reset
    % the offset cue
    if sum(buttons) <= 0
        offsetSet = 0;
    end
    
    [keyIsDown, secs, keyCode] = KbCheck;
    %trialNum = trialNum + 1;
    if keyCode(escapeKey)
        ShowCursor;
        sca;
        return
    elseif keyCode(nextKey)
        WaitSecs(0.2);
        %Generate random Red and Green values
        r_given = randi([50,220],1)/255;
        r_given_exp = randi([50,220],1)/255;
        g_given = randi([100,220],1)/255;

        % Set the colors to Red, Green and Blue
        allColors = [r_given_exp g_given 0; r_given g_given 0; 0 0 1];
        
        % Make our rectangle coordinates
        allRects = nan(4, 3);
        for i = 1:numSqaures
            allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
        end

  
        % Draw the rect to the screen
        Screen('FillRect', window, allColors, allRects);


        %Move to the next trial
        trialNum = trialNum+1;
    end
end


% Clear the screen
sca;