%% STROOP TEST LEVEL 1 %%

%Colors Being Used

% Tasks
% 1. list of colors
% 2. associated color values
% 3. display 
% 4. collect user input 
% 5. store user input in an array for # of trials
% 6. display results


% Clearing the workspace from color blind test before start of the level
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

% Open the screen, defined as 1000 x 1000 matrix
[window, windowRect] = PsychImaging('OpenWindow', 0, [255 255 255], [0 0 1000 1000], screenNumber, grey, [], 32, 2);
%Here screen is opened just for changing the SyncTest preferencesk

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set text size to 40 
Screen('TextSize', window, 40);

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the center coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend function for the screen
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
% particular level, we will use g,r,y,b to stand for each the colors in
% this level
% We will be using escape to escape the task.
greenKey = KbName('g');
redKey = KbName('r');
yellowKey = KbName('y');
blueKey = KbName('b');
escapeKey= KbName('ESCAPE');



%----------------------------------------------------------------------
%                     Colors in words and RGB
%----------------------------------------------------------------------

% For this condition we are using the four most basic colors we can create
% in order to make it fairly easy 
wordList = {'RED', 'GREEN', 'BLUE', 'YELLOW'};%Defining the words to be used
rgbColors = [1 0 0; 0 1 0; 0 0 1; 1 1 0];%defining the color RGB color code for each of the 4 words

% Make the matrix which will determine our condition combinations
condMatrixBase = [sort(repmat([1 2 3 4], 1, 3)); repmat([1 2 3 4], 1, 3)];% This matrix is 12 columns wide, allowing us to record the results of each trial


% This is for the number of trials per condition, giving us a total of 12 trials.
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
        DrawFormattedText(window, 'Welcome to the Stroop Test Level 1! \n\n Press any key to see instructions!',...
            'center', 'center', black); %Welcome screen
        Screen('Flip', window);
        KbStrokeWait;
        DrawFormattedText(window, 'A word will appear on your screen \n\n and will be colored either red, yellow, green or blue.\n\n If green, press the g key! \n\n If red, press the r key! \n\n If yellow, press the y key!, \n\n If blue, press the b key! \n\n Press any key to start!! \n\n  You can quit anytime by pressing ESC!','center', 'center', black)
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

% Set the colors to Red, Green, Blue, BLACK
allColors1 = [1 0 0 ; 0 1 0 ;  0 0 0 ]%Set the RBG values of each rectangle; The order is as follows: [R R R; G G G ; B B B ]; the order is not [1,2,3,] but instead is [1, 4, X,]; This allows for the correct order on screen during the test. This will be more clear in upper levels. 

% Rectangle coordinates; placing rectangles on earlier-specified
% coordinates, starting from LEFT
allRects = nan(4, 3);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% REPEAT!!!! (Necessary in order to create 4 in line rectangles) 
Screen('FillRect', window, allColors1, allRects);

% Base rectangle of 150 x 150 pixels
baseRect = [0 0 150 150];

% Screen X positions of our second set of 3 rectangles
squareXpos = [screenXpixels * 0.8 screenXpixels * 0.6 screenXpixels*.4];%These rectangles begin at the RIGHT side of the screen, with coordinates representing the left most edge; the last of these rectangles overlaps with the second of the first set.
numSquares = length(squareXpos);

% Set the colors to green, blue and yellow
allColors = [ 0 0 1 ; 1 0 1 ; 0 1 0 ]%Set the RBG values of each rectangle; The order is as follows: [R R R ; G G G ; B B B ]; the order is not [1,2,3,] but instead is [4, 3, 2]; This allows for the correct order on screen during the test.

% Rectangle coordinates; placing rectangles on earlier-specified
% coordinates, starting from RIGHT
allRects = nan(4, 3);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end


%Drawing Rectangles and Labeling each with correct labels at specified
%height
Screen('FillRect', window, allColors, allRects);
DrawFormattedText(window,'Red           Yellow          Blue         Green',150,400)

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
        elseif keyCode(redKey)%R key corrosponds to color 1 (red) 
            response = 1;
            respToBeMade = false;
        elseif keyCode(blueKey)%B key corrosponds to color 3 (blue)
            response = 3;
            respToBeMade = false;
        elseif keyCode(yellowKey)%Y key corrosponds to color 4 (yellow)
            response = 4;
            respToBeMade = false;
        elseif keyCode(greenKey)%G key corrosponds to color 2 (green)
            response= 2;
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

 if colorNum == response
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
DrawFormattedText(window, 'You have completed Level One! \n\n Press any key to see your results',...
    'center', 'center', black);

%flip to results screen 
Screen('Flip', window);
KbStrokeWait;

%Display Stroop test 4 reaction time in seconds
DrawFormattedText(window, strcat('Your average RT was:', RTdisp, 'seconds \n Press any key to see your score!'),'center','center',black);
Screen('Flip', window);
KbStrokeWait;

%Display Stroop test 4 score (out of 100); present screen for next level
DrawFormattedText(window, strcat('Your score was:', scoreDisp,  '%! \n Up next is Level 2! \n Click anywhere when you are ready to go on! '),'center','center',black);
Screen('Flip', window);
KbStrokeWait;

%clear, prepare for next level 
sca;



