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
%                       Creating the Window
%----------------------------------------------------------------------

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', 0, [255 255 255], [0 0 1000 1000], screenNumber, black, [], 32, 2);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

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
    'If a match is not possible, click NO MATCH (TBD) \n\n ' ...
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

% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.33 screenXpixels * 0.67];
numSqaures = length(squareXpos);

%Setting up loop to regenerate trials
trialNum = 0;
while trialNum < 5
    
    [keyIsDown,secs, keyCode] = KbCheck;
    %trialNum = trialNum + 1;
    if keyCode(escapeKey)
        ShowCursor;
        sca;
        return
    elseif keyCode(nextKey)
        WaitSecs(0.2);
        %Generate random Red and Green values
        r_given = randi([50,220],1)/255;
        r_given_exp = abs(r_given - randi([50,220],1)/255);
        g_given = randi([100,220],1)/255;
        g_given_exp = abs(g_given - randi([100,220],1)/255);
        
        %Create variable to randomize the trialType
            %trialType 1: r is changed, final squares can match
            %trialType 2: r is changed, final squares cannot match
            %trialType 3: g is changed, final squares can match
            %trialType 4: g is changed, final squares cannot match
        trialType = randi(4,1)
        
        if trialType == 1 %slider should only change r_given_exp
            allColors = [r_given_exp g_given 0; r_given g_given 0; 0 0 1];
        elseif trialType == 2 %slider should only change r_given_exp
            allColors = [r_given_exp g_given_exp 0; r_given g_given 0; 0 0 1];
        elseif trialType == 3 %slider should only change r_given_exp
            allColors = [r_given g_given_exp 0; r_given g_given 0; 0 0 1];
        elseif trialType == 4
            allColors = [r_given_exp g_given_exp 0; r_given g_given 0; 0 0 1];
        end 
        
        % Make our rectangle coordinates
        allRects = nan(4, 3);
        for i = 1:numSqaures
            allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
        end
        
        % Draw the rect to the screen
        Screen('FillRect', window, allColors, allRects);
        
        % Flip to the screen
        Screen('Flip', window);

        %Move to the next trial
        trialNum = trialNum+1;
    end

end

% Clear the screen
sca;