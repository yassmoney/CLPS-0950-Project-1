%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% Create figure window and components
% Create figure window and components
function RGB_v2

%setting values create matrix with random red and green RGB values, within range 100-220
r_given = randi([100,220],1)
g_given = randi([100,220],1)
b_given = 0;


%creating 500x500 matrix 
given_mat = ones(500,'uint8');
img = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
redChannel = img(:,:,1);
fig = uifigure('Position',[100 100 350 275]);



%print image and slider on the same figure
im = uiimage(fig,'Position',[100 100 120 120]);
im.ImageSource = img;
sld = uislider(fig, 'Position',[100 75 120 3]);
btn = uibutton(fig,...
               'Position',[200, 218, 100, 22], 'Text', 'Match!',...
               'ButtonPushedFcn', @(btn,event) plotButtonPushed(btn,img));
%set limits of slider to limits of r_given color channel
sld.Limits = [0 255];

disp(sld.Value)
n = 0;
while n < 1
if sld.Value <= 255
    %set the slider value to the red channel value, save under a new image
    redChannel = sld.Value;
    disp(sld.Value)
    disp(redChannel)
    updatedimg = cat(3, redChannel * given_mat, g_given*given_mat, b_given*given_mat);
    im.ImageSource = updatedimg;
    %display the new image (overlaying the old one)
    %imshow(updatedimg);
end
end
end

function plotButtonPushed(btn,img)
        r_given = randi([100,220],1)
        g_given = randi([100,220],1)
        b_given = 0;
        given_mat = ones(500,'uint8');
       img = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
       imshow(img);
end