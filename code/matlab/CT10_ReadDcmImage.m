clear; clc; close all;
%% Read Image Data
folder0 = 'dcm/train/negative/';
img = dicomread([folder0 '00af6f8c2a3d.dcm']);
img = dicomread(['aa/080ee82d022c.dcm']);
figure(1)
img1 = zeros([1024 1024]) ;
if (size(img,1)>size(img,2))
    img2 = imresize(img,[1024, nan]);
else     
    img2 = imresize(img,[nan, 1024]);
end
img1(1:size(img2,1), 1:size(img2,2)) =  img2;
img2 = imresize(img,[nan, 1024]);


imshow(img_gray);
imshow(img_gray, []);
mean(mean(img));

img_imadjust = imadjust(img);
img_histeq = histeq(img);
img_adapthisteq = adapthisteq(img);
montage({img,img_imadjust,img_histeq,img_adapthisteq},'Size',[1 4]);
title("Original Image and Enhanced Images using imadjust, histeq, and adapthisteq")

figure(2)
[featureVector,hogVisualization] = extractHOGFeatures(img_adapthisteq,...
    'CellSize',[4 4],'BlockSize', [2 2],'BlockOverlap',[1 1]);
plot(hogVisualization)
% [featureVector,hogVisualization] = extractHOGFeatures(img_adapthisteq,...
%     'CellSize',[8 8],'BlockSize', [2 2],'BlockOverlap',[1 1]);
imshow(img_adapthisteq); 
hold on;
plot(hogVisualization)
hold off;
return 

% Anisotropic diffusion filtering of images
% J = imdiffusefilt(I)
% J = imdiffusefilt(I,Name,Value)
imgGamma = imadjust(img,[0 1],[0 1], 3);
figure(2)
imshow(imgGamma);
% title("Original Image and Enhanced Images using imadjust, histeq, and adapthisteq")
return 
dcm_resize = imresize(img,[50 50]);
imshow(dcm_resize)
return 
%% Show 20 Random Images
files = dir([folder0 '*.dcm']);
figure;
perm = randperm(1000,20);
for i = 1:20
    subplot(4,5,i);
    img = dicomread([folder0 files(perm(i)).name]);
    imshow(histeq(img));
end

