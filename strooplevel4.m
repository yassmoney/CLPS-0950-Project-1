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
vermontgreenKey = KbName('v');
christmasgreenKey = KbName('c');
escapeKey= KbName('ESCAPE');


%----------------------------------------------------------------------
%                     Colors in words and RGB
%----------------------------------------------------------------------

% For this condition we are using four types of Green!
wordList = {'GRASS GREEN', 'FERN GREEN', 'VERMONT GREEN', 'CHRISTMAS GREEN'};
rgbColors = [0.2 0.8 0; 0.2 0.7 0.1; 0.2 0.7 0.4; 0.2 0.9 0.5];

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
        DrawFormattedText(window, 'A word will appear on your screen \n\n and will be colored either grass green, fern green, \n\n Vermont green or Christmas green. \n\n If grass green, press the G key! \n\n If fern green, press the F key! \n\n If Vermont green, press the V key!, \n\n If Christmas green, press the C key! \n\n Press any key to start!! \n\n  You can quit anytime by pressing ESC!','center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
  
%----------------------------------------------------------------------
%                       Priming Screen for Colors: 
%----------------------------------------------------------------------

% First, need to get actual size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Find center coordinate (to be used for center rectange, if using 3) 
[xCenter, yCenter] = RectCenter(windowRect);

% Set size of rectangle (We are using 150 pixels by 150 pixels because we
% need 4 of them to fit the screen
baseRect = [0 0 150 150];

% Screen X positions of our THREE rectangles (we must use three and have an
% overlapping rectangle) 
squareXpos = [screenXpixels * 0.2 screenXpixels * 0.4 screenXpixels*.6];% this represents the left edge placement of three rectangles, begining on the LEFT)  
numSquares = length(squareXpos);%this is just referring to the right most edge of each

% Set the colors to 'GRASS GREEN, FERN GREEN, VERMONT GREEN, CHRISTMAS GREEN' 
allColors1 = [.2 .2 .2 .2 ; .8 .7 .9 .7;  0 .4 .5 .1] %Set the RBG values of each rectangle; The order is as follows: [R R R R; G G G G; B B B B]; the order is not [1,2,3,4,] but instead is [1, 4, 3, 2]; This allows for the correct order on screen during the test. 

% Rectangle coordinates; placing rectangles on earlier-specified
% coordinates
allRects = nan(4, 4); 
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% REPEAT!!!! (Necessary in order to create 4 in line rectangles) 
Screen('FillRect', window, allColors1, allRects);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 150 150];

% Screen X positions of our four rectangles
squareXpos = [screenXpixels * 0.8 screenXpixels * 0.6 screenXpixels*.4];
numSquares = length(squareXpos);

% Set the colors to GRASS GREEN, FERN GREEN, VERDANT GREEN, CHRISTMAS GREEN 
allColors = [ .2 .2 .2 .2 ; .9 .7 .7 .8;  .5 .4 .1 0]

% Make our rectangle coordinates
allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Draw the rect to the screen
Screen('FillRect', window, allColors, allRects);
DrawFormattedText(window,'Grass        Fern       Vermont      Christmas',150,400)

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

    end
%----------------------------------------------------------------------
%                       ACTUAL TEST!! : 
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

        % create the word "Color" in a randomly chose color 
        DrawFormattedText(window, char(theWord), 'center', 'center', theColor);

        % Checking the keyboard for accuracy of keys; necessary in order to
        % correctly calculate the accuracy of trials. Setting accurate
        % response to corrosponding keys
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(grassgreenKey) %G key corrosponds to color 1 (grass) 
            response = 1;
            respToBeMade = false;
        elseif keyCode(vermontgreenKey)%V key corrosponds to color 3 (Vermont) 
            response = 3;
            respToBeMade = false;
        elseif keyCode(christmasgreenKey)%C key corrosponds to color 4 (Christmas)
            response = 4;
            respToBeMade = false;
        elseif keyCode(ferngreenKey)%F key corrosponds to color 2 (Fern)
            response = 2;
            respToBeMade = false;
        end
    

        % Change screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    tEnd = GetSecs;%recording the end time of trial 
    rt = tEnd - tStart; %calculating response time; End of trial - Start of trial  

    % Record the trial data into data matrix
    respMat(1, trial) = wordNum; %number corrosponding to word (1-4)
    respMat(2, trial) = colorNum; %number corrospondong to color of word (1-4) 
    respMat(3, trial) = response; %number corrospondong to color chosen by test taker (1-4) 
    respMat(4, trial) = rt; %response time in seconds 
 if colorNum == response %boolean response; if number representing color of words is a match to the color chosen, considered correct (1), if not matched, incorrect (0)
    respMat(5,trial) = 1
 else
     respMat(5,trial)= 0
 end

end

%----------------------------------------------------------------------
%                      Accuracy and Response Time Data: 
%----------------------------------------------------------------------
% Setting results; Average reaction time and accuracy of trial 
%reaction time; average of 12 trials 
averagereaction= sum(respMat(4,:))
averagert= averagereaction/12

%accuracy of trials; average of 12 trials multiplied by 100 for a percentage out of 100.  
accuracy= sum((respMat(5,:)))
accuracypercent= (accuracy/12)*100

% setting variables for display results (to be utilized in later screen)
RTdisp= num2str(averagert)
scoreDisp= num2str(accuracypercent)



%Flip to post-experiment screen; Formatting text screen
DrawFormattedText(window, 'You have completed Level Four! Congrats! \n\n Press any key to see your results',...
    'center', 'center', black);

%flip to results screen 
Screen('Flip', window);
KbStrokeWait;

%Display Stroop test 4 reaction time in seconds
DrawFormattedText(window, strcat('Your average RT was:', RTdisp, 'seconds \n Press any key to see your score!'),'center','center',black);
Screen('Flip', window);
KbStrokeWait;

%Display Stroop test 4 score (out of 100)
DrawFormattedText(window, strcat('Your score was:', scoreDisp,  '%! \n Thanks for playing! Press any key to end! '),'center','center',black);
Screen('Flip', window);
KbStrokeWait;
sca;