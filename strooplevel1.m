%% STROOP TEST LEVEL 1 %%

%Colors Being Used

% Tasks
% 1. list of colors
% 2. associated color values
% 3. display 
% 4. collect user input 
% 5. store user input in an array for # of trials
% 6. display results

%Set Colors for Level
words= ['red';'green';'blue';'yellow']; % this is setting the words we will use for Level 1
colorvalues= [255 0 0; 0 255 0; 0 0 255;255 255 0] % this sets the color values we are going to use

%Initialize Variables
numberofcolors= 4;
trials= 10;
congruentpairs= [];
congruentrts= zeros(trials,:) %check semicolon
congruenterrors= [];
incongruentpairs=[]; 
incongruentrts= zeros(trials,:) %check semicolon
incongruenterrors= [];


%Running the Stroop Test Trials for congruent trials
for ii= 1:trials % setting this to run the indicated number of trials
    display= randi(numberofcolors) % randomly choosing a number correlated to a color to display
    displaytext= words(display) %using the randomly chosen color to display the word
    displaycolor=colors(display)%using the randomly chosen color to color the word
 tic; %starting a timer
 congruentpairs(ii,:)= clock; %creating an array for data of the congruent pairs
 response= getkey(); 
 time=toc;

 if response == 114

 congruentdata = [congruentdata,time]
  



    

