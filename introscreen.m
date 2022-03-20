%% Intro Page %%


pic= imread("IMG_9145.jpeg","jpg")
imshow(pic)

position = [300 800]; 
box_color = {'yellow'};
text_str= ' This is the Stroop Groop :)'

RGB = insertText(pic,position,text_str,'FontSize',50,'BoxColor',...
    box_color,'BoxOpacity',.9,'TextColor','red');
figure
imshow(RGB)


%% Merging Content %%

KbStrokeWait;

run("RGB_v10.m")

if RGBscore <=.25
    run("strooplevel1.m")
elseif RGBscore <=.5
    run("strooplevel2.m")
elseif RGBscore <=.75
    run("strooplevel3.m")
else 
    run('strooplevel4.m')






