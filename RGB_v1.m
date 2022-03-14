%RGB Anomaloscope 

r_given = randi([100,220],1)
g_given = randi([100,220],1)
b_given = 0;

given_mat = ones(500,'uint8');
given_img = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
exp_img = given_img;

%Test images
img3 = ones(500, 'uint8');
img4 = cat(3, img3, img3, img3);

%Testing multi-panel figures
fig = uifigure;
    pnl = uipanel(fig);
        img = uiimage(pnl,'ImageSource',exp_img);
        sld = uislider(pnl,'Position',[75 50 150 3]);
        sld.Limits = [0,255];

    pnl2 = uipanel(fig);
        img2 = uiimage(pnl2, 'ImageSource', img4);

%Giving up/creating two separate figures (fig has exp_pic and slider), fig2 has given_pic only 
fig = uifigure;
    pnl = uipanel(fig);
        img = uiimage(pnl,'ImageSource',exp_img);
        sld = uislider(pnl,'Position',[75 50 150 3]);
        sld.Limits = [0,255];

fig2 = uifigure;
    img2 = uiimage(fig2, 'ImageSource', given_img);

%Different combination of figures/slider
figure %color blocks
    subplot(1,2,1)
        imshow(exp_img);
    subplot(1,2,2)
        imshow(given_img);

fig = uifigure; %slider
    sld = uislider(fig,'Position',[75 50 150 3]);
    sld.Limits = [0,255];
        
    