%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% Create figure window and components
% Create figure window and components
function RGB_v2

r_given = randi([100,220],1)
g_given = randi([100,220],1)
b_given = 0;

given_mat = ones(500,'uint8');
img1 = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
imshow(img1)
fig = uifigure('Position',[100 100 350 275]);

im = uiimage(fig,'Position',[100 100 120 120]);
im.ImageSource = ''
sld = uislider(fig, 'Position',[100 75 120 3], 'ValueChangedFcn',@(sld,event) updateGauge(sld,im));

end


