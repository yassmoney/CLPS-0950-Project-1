
newpic= imread("IMG_9390.jpg","jpg");
position = [300 800]; 
box_color = {'yellow'};
text_str= ' This is the Stroop Groop after finishing our project! Bye!!:)'

StroopGroop = insertText(newpic,position,text_str,'FontSize',50,'BoxColor',...
    box_color,'BoxOpacity',.9,'TextColor','red');
figure
imshow(StroopGroop)
KbStrokeWait;
sca