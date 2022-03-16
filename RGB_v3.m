%RGB_v3 - Roshan's Workspace

r_given = randi([100,220],1)
g_given = randi([100,220],1)
b_given = 0;

given_mat = ones(500,'uint8');
given_img = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
exp_img = given_img;

fig = uifigure; %slider
    fig.Color = [122/255 249/255 243/255];
    %set(gcf, 'color', [1 1 1])
    pnl = uipanel(fig, 'Title', 'Slider','BackgroundColor',[1 1 1],'Position',[25 50 300 300]);
    img = uiimage(pnl,'ImageSource',exp_img);
    sld = uislider(pnl, 'Position',[75 50 150 3]);
    sld.Limits = [0,255];

    pnl2 = uipanel(fig, 'Title','Given Color','BackgroundColor',...
        [1 1 1], 'Position', [400 50 300 300]);
    img = uiimage(pnl2, 'ImageSource',given_img);

disp(slider)