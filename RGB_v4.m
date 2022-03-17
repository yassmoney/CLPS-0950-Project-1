%RGB_v4 Roshan's Workspace

r_given = randi([50,220],1)
g_given = randi([100,220],1)
b_given = 0;

given_mat = ones(500,'uint8');
given_img_r = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
exp_img_r = given_img_r; exp_img_r(:,:,1) = randi([50,220],1);

fig = uifigure('Position', [50 50 725 400]); %slider
    fig.Color = [122/255 249/255 243/255];
    %set(gcf, 'color', [1 1 1])
    pnl = uipanel(fig, 'Title', 'Slider','BackgroundColor',[1 1 1],'Position',[25 50 300 300]);
    img = uiimage(pnl,'ImageSource',exp_img_r);
    sld = uislider(pnl, 'Position',[75 50 150 3]);
    sld.Limits = [0,255];

    pnl2 = uipanel(fig, 'Title','Given Color','BackgroundColor',...
        [1 1 1], 'Position', [400 50 300 300]);
    img = uiimage(pnl2, 'ImageSource',given_img_r);

    disp(sld.Value)

n = 0;
while n < 1
    if sld.Value <= 255
        %set the slider value to the red channel value, save under a new image
        redChannel = sld.Value;
        disp(sld.Value);
        disp(redChannel);
        updatedimg = cat(3, redChannel * given_mat, g_given*given_mat, b_given*given_mat);
        img = uiimage(pnl,'ImageSource',updatedimg);
        %display the new image (overlaying the old one)
        imshow(updatedimg);
    end
end

