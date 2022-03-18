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

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];

% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.33 screenXpixels * 0.67];
numSqaures = length(squareXpos);

%Setting up loop to regenerate trials
trialNum = 0
while trialNum < 5
    %Generate random Red and Green values
    r_given = randi([50,220],1)/255;
    r_given_exp = randi([50,220],1)/255;
    g_given = randi([100,220],1)/255;
    
    % Set the colors to Red, Green and Blue
    allColors = [r_given g_given 0; r_given_exp 0 0; 0 0 1];
    
    % Make our rectangle coordinates
    allRects = nan(4, 3);
    for i = 1:numSqaures
        allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
    end
    
    % Draw the rect to the screen
    Screen('FillRect', window, allColors, allRects);
    
    % Flip to the screen
    Screen('Flip', window);

    %Wait for a key press
    KbStrokeWait;

%     [keyIsDown,secs, keyCode] = KbCheck;
    trialNum = trialNum + 1;
%     if keyCode(escapeKey)
%         ShowCursor;
%         sca;
%         return
%     elseif keyCode(nextKey)
%         WaitSecs(1);
%         trialNum = trialNum+1;
%     end

%elseif keyCode(escapeKey)
        %ShowCursor;
        %sca;
        %return
    %elseif keyCode(nextKey)
        %WaitSecs(1);
        %trialNum = trialNum+1;
    %end
%end
end

% Clear the screen
sca;