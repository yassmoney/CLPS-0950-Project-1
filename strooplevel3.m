% Clearing the workspace before start of level
close all;
clear;
sca;

% Setting up default values 
PsychDefaultSetup(2);

% Create a random number generator
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

% Set the text size
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

% Interstimulus interval time in seconds and frames
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Number of frames to wait before re-drawing
waitframes = 1;


%----------------------------------------------------------------------
%                       Keyboard Presses
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
skyblueKey = KbName('s');
waterblueKey = KbName('w');
darkblueKey = KbName('d');
royalblueKey = KbName('r');
escapeKey= KbName('ESCAPE');


%----------------------------------------------------------------------
%                     Colors in words and RGB
%----------------------------------------------------------------------

% We are going to use four colors!
wordList = {'SKY BLUE', 'WATER BLUE', 'DARK BLUE', 'ROYAL BLUE'};
rgbColors = [0.2 0.6 1; 0.3 0.8 0.9; 0.2 0.1 0.4; 0.1 0.1 0.8];

% Make the matrix which will determine our condition combinations
condMatrixBase = [sort(repmat([1 2 3 4], 1, 3)); repmat([1 2 3 4], 1, 3)];

% Number of trials per condition. We set this to one to give
% us a total of 16 trials.
trialsPerCondition = 1;

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, trialsPerCondition);

% Get the size of the matrix
[~, numTrials] = size(condMatrix);

% Randomise the conditions
shuffler = Shuffle(1:numTrials);
condMatrixShuffled = condMatrix(:, shuffler);


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a four row matrix the first row will record the word we present,
% the second row the color the word it written in, the third row the key
% they respond with and the final row the time they took to make there response.
respMat = nan(4, numTrials);


%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

% Animation loop: we loop for the total number of trials
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
        DrawFormattedText(window, 'Welcome to the Stroop Test Level 3! \n\n Press any key to see instructions!',...
            'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
        DrawFormattedText(window, 'A word will appear on your screen \n\n and will be colored either sky blue, water blue, dark blue or royal blue. \n\n If sky blue, press the S key! \n\n If water blue, press the W key! \n\n If dark blue, press the D key!, \n\n If royal blue, press the R key! \n\n Press any key to start!! \n\n  You can quit anytime by pressing ESC!','center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
    end
%----------------------------------------------------------------------
%                       Priming Screen for Colors: 
%----------------------------------------------------------------------
        % Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 150 150];

% Screen X positions of our four rectangles
squareXpos = [screenXpixels * 0.2 screenXpixels * 0.4 screenXpixels*.6];
numSquares = length(squareXpos);

% Set the colors to SKY BLUE, WATER BLUE, DARK BLUE, ROYAL BLUE 
allColors1 = [.2 .2 .1 .3 ; .6 .1 .1 .8;  1 .4 .8 .9]

% Make our rectangle coordinates
allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Draw the rect to the screen
Screen('FillRect', window, allColors1, allRects);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 150 150];

% Screen X positions of our four rectangles
squareXpos = [screenXpixels * 0.8 screenXpixels * 0.6 screenXpixels*.4];
numSquares = length(squareXpos);

% Set the colors to SKY BLUE, WATER BLUE, DARK BLUE, ROYAL BLUE 
allColors = [ .1 .2 .3 .2 ; .1 .1 .8 .6;  .8 .4 .9 1 ]

% Make our rectangle coordinates
allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Draw the rect to the screen
Screen('FillRect', window, allColors, allRects);
DrawFormattedText(window,'  Sky         Water           Dark         Royal',150,400)

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;     

end


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

    % Now present the word in continuous loops until the person presses a
    % key to respond. We take a time stamp before and after to calculate
    % our reaction time. We could do this directly with the vbl time stamps,
    % but for the purposes of this introductory demo we will use GetSecs.
    %
    % The person should be asked to respond to either the written word or
    % the color the word is written in. They make thier response with the
    % three arrow key. They should press "Left" for "Red", "Down" for
    % "Green" and "Right" for "Blue".
    tStart = GetSecs;
    while respToBeMade == true

        % Draw the word
        DrawFormattedText(window, char(theWord), 'center', 'center', theColor);

        % Check the keyboard. The person should press the
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(skyblueKey)
            response = 1;
            respToBeMade = false;
        elseif keyCode(waterblueKey)
            response = 2;
            respToBeMade = false;
        elseif keyCode(darkblueKey)
            response = 3;
            respToBeMade = false;
        elseif keyCode(royalblueKey)
            response = 4;
            respToBeMade = false;
        end

        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    tEnd = GetSecs;
    rt = tEnd - tStart;

    % Record the trial data into out data matrix
    respMat(1, trial) = wordNum;
    respMat(2, trial) = colorNum;
    respMat(3, trial) = response;
    respMat(4, trial) = rt;

    if colorNum == response
    respMat(5,trial) = 1
 else
     respMat(5,trial)= 0
    end

% Result Data
averagereaction= sum(respMat(4,:))
averagert= averagereaction/12
 
accuracy= sum((respMat(5,:)))
accuracypercent= (accuracy/12)*100

% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(window, 'You have completed Level Three! \n\n Press any key to see your results',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
DrawFormattedText(window, 'You have completed Level One! \n\n Press any key to see your results',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
DrawFormattedText(window, sprintf('Your average reaction time is: %d\n Press any key to see your score!', averagert),'center','center',black);
Screen('Flip', window);
KbStrokeWait;
DrawFormattedText(window, sprintf('Your score was: %d\n ', accuracypercent),'center','center',black);
Screen('Flip', window);
KbStrokeWait;
sca;