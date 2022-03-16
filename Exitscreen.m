url = 'https://media3.giphy.com/media/Y1pwhvxvl50spPcwva/giphy.gif?cid=ecf05e4743w1swejm43kme52j2fs3f9tf7e6gim08p7dl0u5&rid=giphy.gif&ct=g';
img = webread(url);

fullFileName = 'Users/joenapolitano/Documents/GitHub/CLPS-0950-Project-1/giphy.gif'; 
[gifImage, cmap] = imread(fullFileName, 'Frames', 'all');
size(gifImage);

implay(gifImage);