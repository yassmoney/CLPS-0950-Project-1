% Clearing the workspace before start of level
close all;
clear;
sca;

% Setting up default values
PsychDefaultSetup(2);

% Random number generator
rand('seed', sum(100 * clock));

% Setting the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / .5; % making a lighter background
black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', 0, [255 255 255], [0 0 1000 1000], screenNumber, grey, [], 32, 2);

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set  text size
Screen('TextSize', window, 40);

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

% Stimulus interval time in seconds and frames
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Number of frames to wait before next stimulus
waitframes = 1;


%----------------------------------------------------------------------
%                       Keyboard Presses
%----------------------------------------------------------------------

% Here we are defining the keys that we need to use for responses. In this
% particular level, we will use g,f,v,c as they have not yet been used.
% Again, we will be using escape to escape the task.
grassgreenKey = KbName('g');
ferngreenKey = KbName('f');
verdantgreenKey = KbName('v');
christmasgreenKey = KbName('c');
escapeKey= KbName('ESCAPE');


%----------------------------------------------------------------------
%                     Colors in words and RGB
%----------------------------------------------------------------------

% For this condition we are using four types of Green!
wordList = {'GRASS GREEN', 'FERN GREEN', 'VERMONT GREEN', 'CHRISTMAS GREEN'};
rgbColors = [0.2 0.8 0; 0.2 0.7 0.1; 0.2 0.7 0.3; 0.2 0.9 0.5];

% Make the matrix which will determine our condition combinations
condMatrixBase = [sort(repmat([1 2 3 4], 1, 3)); repmat([1 2 3 4], 1, 3)];

% This is for the number of trials per condition, giving us a total of 12 trials.
trialsPerCondition = 1;

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, trialsPerCondition);

% Size of matrix
[~, numTrials] = size(condMatrix);

% This is here to randomize the conditions
shuffler = Shuffle(1:numTrials);
condMatrixShuffled = condMatrix(:, shuffler);


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% Four row matrix; 
% row 1 = word presented; 
% row 2 = color of word; 
% row 3 = key which was pressed in response to stimulus; 
% row 4 = response time 
respMat = nan(4, numTrials);


%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

% For loop for total number of trials
for trial = 1:numTrials

    % Word and color number
    wordNum = condMatrixShuffled(1, trial);
    colorNum = condMatrixShuffled(2, trial);

    % The color word and the color it is drawn in
    theWord = wordList(wordNum);
    theColor = rgbColors(colorNum, :);

    % Cue to determine whether a response has been made
    respToBeMade = true;

    % If this is the first trial we present a start screen and wait for a
    % key-press
    if trial == 1
        DrawFormattedText(window, 'Welcome to the Stroop Test Level 4! \n\n Press any key to see instructions!',...
            'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
        DrawFormattedText(window, 'A word will appear on your screen \n\n and will be colored either grass green, fern green, Vermont green or Christmas green. \n\n If grass green, press the G key! \n\n If fern green, press the F key! \n\n If verdant green, press the V key!, \n\n If Christmas green, press the C key! \n\n Press any key to start!! \n\n  You can quit anytime by pressing ESC!','center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
    end
%----------------------------------------------------------------------
%                     Setting Colors for Participants 
%----------------------------------------------------------------------
        
        % Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];

% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
numSqaures = length(squareXpos);

% Set the colors to 'GRASS GREEN', 'FERN GREEN', 'VERMONT GREEN', 'CHRISTMAS GREEN'
allColors = [0.2 0.8 0; 0.2 0.7 0.1; 0.2 0.7 0.3; 0.2 0.9 0.5];

% Make our rectangle coordinates
allRects = nan(4, 3);
for i = 1:numSqaures
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Draw the rect to the screen
Screen('FillRect', window, allColors, allRects);

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;
    end
%----------------------------------------------------------------------
    % Flip again to sync us to the vertical retrace at the same time as
    % drawing our fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
    vbl = Screen('Flip', window);

    % Now we present the isi interval with fixation point minus one frame
    % because we presented the fixation point once already when getting a
    % time stamp
    for frame = 1:isiTimeFrames - 1

        % Draw the fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end

    tStart = GetSecs;
    while respToBeMade == true

        % create the word
        DrawFormattedText(window, char(theWord), 'center', 'center', theColor);

        % Check the keyboard. The person should press the
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(grassgreenKey)
            response = 1;
            respToBeMade = false;
        elseif keyCode(verdantgreenKey)
            response = 2;
            respToBeMade = false;
        elseif keyCode(christmasgreenKey)
            response = 3;
            respToBeMade = false
        elseif keyCode(ferngreenKey)
            response = 4;
            respToBeMade = false;
        end

        % Change screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    tEnd = GetSecs;
    rt = tEnd - tStart;

    % Record the trial data into out data matrix
    respMat(1, trial) = wordNum;
    respMat(2, trial) = colorNum;
    respMat(3, trial) = response;
    respMat(4, trial) = rt;

end

% Result Data; Average reaction time and accuracy of trial 
averagereaction= sum(respMat(4,:))
averagert= averagereaction/12
 
accuracy= sum((respMat(5,:)))
accuracypercent= (accuracy/12)*100

% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(window, 'You have completed Level Four! \n\n Press any key to see your results',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
DrawFormattedText(window,' Below you will find your accuracy \n\n and your average reaction time!','center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
sca;