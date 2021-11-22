function output = dicompreprocess(filename)

% Code for Simple CNN model
dcm = dicomread(filename);
dcm_resize = imresize(dcm,[50 50]);
output = dcm_resize;

% Code for Transfer Learning Model
% dcm_resize = imresize(dcm,[227 227]);
% output = cat(3,dcm_resize,dcm_resize,dcm_resize);

end