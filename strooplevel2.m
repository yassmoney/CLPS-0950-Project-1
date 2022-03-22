% Clearing the workspace before start of level
close all;
clear;
sca;

%----------------------------------------------------------------------
%                       Defining Information
%----------------------------------------------------------------------


% Setting up default values
PsychDefaultSetup(2);

% Create a random number generator
rand('seed', sum(100 * clock));

% Setting the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / .5; % making a lighter background (otherwise will play on grey, which makes contrast too difficult to discern
black = BlackIndex(screenNumber);

% Open the screen, defined as 1000 x 1000 white matrix
[window, windowRect] = PsychImaging('OpenWindow', 0, [255 255 255], [0 0 1000 1000], screenNumber, grey, [], 32, 2);
% Flip to clear
Screen('Flip', window);

% Query the frame duration   
ifi = Screen('GetFlipInterval', window);

% Set text size to 40
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

% Number of frames to wait before re-drawing
waitframes = 1;


%----------------------------------------------------------------------
%                       Keyboard Presses
%----------------------------------------------------------------------

% Here we are defining the keys that we need to use for responses. In this
% particular level, we will use p,o,l,m as they have not yet been used.
% Again, we will be using escape to escape the task.
pinkKey = KbName('p'); %for color 1
orangeKey = KbName('o'); %for color 2
lavenderKey = KbName('l'); %for color 3
maroonKey = KbName('m'); %for color 4
escapeKey= KbName('ESCAPE'); % end

%----------------------------------------------------------------------
%                     Colors in words and RGB
%----------------------------------------------------------------------

% For this condition we are using four colors which are less obviously
% different than in level one
wordList = {'PINK', 'ORANGE', 'LAVENDER', 'MAROON'};%Defining the color names to be used
rgbColors = [0.9 0.6 0.7; 1 0.6 0; 0.9 0.6 1; 0.5 0 0.1];%defining the color RGB color code for each of the 4 words

% Make the matrix which will determine our condition combinations
condMatrixBase = [sort(repmat([1 2 3 4], 1, 3)); repmat([1 2 3 4], 1, 3)];% This matrix is 12 columns wide, allowing us to record the results of each trial

% Number of trials per condition. We set this to one to give
% us a total of 12 trials.
trialsPerCondition = 1;

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, trialsPerCondition);

% Get the size of the matrix
[~, numTrials] = size(condMatrix);

% To randomize the conditions so that a randomly chosen word is presented in a
% randomly chosen color
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
        DrawFormattedText(window, 'Welcome to the Stroop Test Level 2! \n\n Press any key to see instructions!',...
            'center', 'center', black);%Welcome screen
        Screen('Flip', window);
        KbStrokeWait;
        DrawFormattedText(window, 'A word will appear on your screen \n\n and will be colored either \n\n pink, orange, lavender or maroon. \n\n If pink, press the P key! \n\n If orange, press the O key! \n\n If lavender, press the L key!, \n\n If maroon, press the M key! \n\n Press any key to start!! \n\n  You can quit anytime by pressing ESC!','center', 'center', black);
        Screen('Flip', window);%Task directions text
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

% Screen X positions of our THREE rectangles (we must use two sets of three and have an
% overlapping rectangle) 
squareXpos = [screenXpixels * 0.2 screenXpixels * 0.4 screenXpixels*.6];% this represents the left edge placement of three rectangles, begining on the LEFT)  
numSquares = length(squareXpos);%this is just referring to the right most edge of each

% Set the colors to Pink, Lavender, Maroon, and Orange
allColors1 = [.9 .9 1 .5 ; .6 .6 .6 0;  .7 1 0 .1 ]%Set the RBG values of each rectangle; The order is as follows: [R R R R; G G G G; B B B B]; the order is not [1,2,3,4,] but instead is [1, 4, 3, 2]; This allows for the correct order on screen during the test. 

% Rectangle coordinates; placing rectangles on earlier-specified
% coordinates, starting from LEFT
allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% REPEAT!!!! (Necessary in order to create 4 in line rectangles) 
Screen('FillRect', window, allColors1, allRects);

% Base rectangle of 150 x 150 pixels
baseRect = [0 0 150 150];

% Screen X positions of our second set of 3 rectangles
squareXpos = [screenXpixels * 0.8 screenXpixels * 0.6 screenXpixels*.4];
numSquares = length(squareXpos);

% Set the colors to Pink, Lavender, Maroon, and Orange
allColors = [ .5 .9 1 .5 ; 0 .6 .6 0;  .1 1 0 .1  ]%Set the RBG values of each rectangle; The order is as follows: [R R R R; G G G G; B B B B]; the order is not [1,2,3,4,] but instead is [4, 3, 2, 1]; This allows for the correct order on screen during the test. 

% Rectangle coordinates; placing rectangles on earlier-specified
% coordinates, starting from RIGHT
allRects = nan(4, 4);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

%Drawing Rectangles and Labeling each with correct labels at specified
%height
Screen('FillRect', window, allColors, allRects);
DrawFormattedText(window,'Pink          Orange      Lavender     Maroon  ',150,400)%labels for each square in order 1,2,3,4

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

    end
%----------------------------------------------------------------------
%                       ACTUAL TEST!! : 
%----------------------------------------------------------------------
     % Flip to new screen, begin with central dot to prime spot where words
    % will appear
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
    vbl = Screen('Flip', window);

    %Present isi interval, but subtract 1 interval for fixation dot 
    for frame = 1:isiTimeFrames - 1

        % Draw the fixation point at screen center 
        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end

    tStart = GetSecs;%recording the start time of trial 
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
        elseif keyCode(pinkKey)%P key corrosponds to color 1 (pink) 
            response = 1;
            respToBeMade = false;
        elseif keyCode(maroonKey)%M key corrosponds to color 4 (maroon) 
            response = 4;
            respToBeMade = false;
        elseif keyCode(orangeKey)%O key corrosponds to color 2 (orange)
            response = 2;
            respToBeMade = false;
        elseif keyCode(lavenderKey)%L key corrosponds to color 4 (lavender)
            response = 3;
            respToBeMade = false;
        end

            % Change screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    tEnd = GetSecs;%recording the end time of trial 
    rt = tEnd - tStart;%calculating response time; End of trial - Start of trial  

    % Record the trial data into out data matrix
    respMat(1, trial) = wordNum;%number corrosponding to word (1-4)
    respMat(2, trial) = colorNum;%number corrosponding to color of word (1-4) 
    respMat(3, trial) = response;%number corrosponding to color chosen by test taker (1-4) 
    respMat(4, trial) = rt;%response time in seconds 
   
    if colorNum == response%boolean response; if number representing color of words is a match to the color chosen, considered correct (1), if not matched, incorrect (0)
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
DrawFormattedText(window, 'You have completed Level Two! \n\n Press any key to see your results',...
    'center', 'center', black);

%flip to results screen 
Screen('Flip', window);
KbStrokeWait;

%Display Stroop test 4 reaction time in seconds
DrawFormattedText(window, strcat('Your average RT was:', RTdisp, 'seconds \n Press any key to see your score!'),'center','center',black);
Screen('Flip', window);
KbStrokeWait;

%Display Stroop test 4 score (out of 100); present screen for next level
DrawFormattedText(window, strcat('Your score was:', scoreDisp,  '%! \n Get ready for Level 3! Press any key to start! '),'center','center',black);
Screen('Flip', window);
KbStrokeWait;

%clear, prepare for next level 
sca;
