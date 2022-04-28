  %% Intro Page %%


% This section calls in a photo we took at the start of this project! and
% displays a figure introducing the stroop groop

pic= imread("IMG_9145.jpeg","jpg");


position = [-3 800]; 
box_color = {'yellow'};
text_str= 'This is the Stroop Groop! Press any key to begin! :)'

Stroop = insertText(pic,position,text_str,'FontSize',50,'BoxColor',...
    box_color,'BoxOpacity',.9,'TextColor','red');
figure
imshow(Stroop)
KbStrokeWait

%% MENU SCREEN %%

% Clearing the workspace 
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

% Here we are defining the keys that we need to use for responses.
% We will be using escape to escape the task.
upKey = KbName('uparrow');
downKey = KbName('downarrow');
leftKey = KbName('leftarrow');
rightKey = KbName('rightarrow');
escapeKey= KbName('ESCAPE');

Screen('Flip', window);
DrawFormattedText(window, 'Choose which task you want to play! \n\n For RGB Anomaloscope, press the up key! \n\n For Priming Test, press the down key! \n\n For Stroop Test, press the left key!, \n\n For the Working Memory Test, press the right key! \n\n  You can quit anytime by pressing ESC!','center', 'center', black); %game menu
Screen('Flip', window);
KbStrokeWait

[keyIsDown,secs, keyCode] = KbCheck;
if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
elseif keyCode(upKey)
            run("RGB_v11.m")
elseif keyCode(leftKey)
            run("strooplevel1.m")
            run("strooplevel2.m")
            run("strooplevel3.m")
            run('strooplevel4.m')
          
  
end



