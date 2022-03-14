%RGB Anomaloscope 

r_given = randi([100,220],1)
g_given = randi([100,220],1)
b_given = 0;

given_mat = ones(500,'uint8');
img1 = cat(3, r_given*given_mat, g_given*given_mat, b_given*given_mat);
imshow(img1)