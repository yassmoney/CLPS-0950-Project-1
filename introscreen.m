%% Intro Page %%



pic= imread("IMG_9145.jpeg","jpg")

position = [300 800]; 
box_color = {'yellow'};
text_str= ' This is the Stroop Groop :)'

RGB = insertText(pic,position,text_str,'FontSize',50,'BoxColor',...
    box_color,'BoxOpacity',.9,'TextColor','red');
figure
imshow(RGB)

waitforbuttonpress
