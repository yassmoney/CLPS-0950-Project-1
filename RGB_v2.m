%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% Create figure window and components
% Create figure window and components
function RGB_v2

r_given = randi([100,220],1)
g_given = randi([100,220],1)
b_given = 0;

given_mat = ones(500,'uint8');
img = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
imshow(img)
fig = uifigure('Position',[100 100 350 275]);

im = uiimage(fig,'Position',[100 100 120 120]);
im.ImageSource = img;
sld = uislider(fig, 'Position',[100 75 120 3], 'ValueChangedFcn',@ sld,event);

redChannel = img(:, :, 1);
greenChannel = img(:, :, 2);
blueChannel = img(:, :, 3);
 handles.img = img;
 guidata(hObject, handles);

if isfield(handles, 'img')
     img = handles.img;
     slope = handles.sldSlope.Value;
intercept = handles.sldIntercept.Value;
redChannel = uint8(double(redChannel) * slope + intercept);
updatedImage = cat(3, redChannel, greenChannel, blueChannel);
     imshow(updatedImg);
     handles.img = updatedImg;
     guidata(hObject, handles);
end
end

function sld_Callback(hObject, eventdata, handles)
val=0.1*get(hObject,'Value')-0.1;
imbright=im2+val;
axes(handles.axes1);
imshow(imbright);
impixelinfo
end