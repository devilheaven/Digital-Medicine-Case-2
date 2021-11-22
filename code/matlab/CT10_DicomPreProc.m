function output = CT10_DicomPreProc(filename)
% output = CT10_DicomPreProcCnn(filename)
global imgPreProcParam; 

%% Code for Simple CNN model
img = dicomread(filename);


%% average process
if (imgPreProcParam.avgFilt)
%   [gradThresh,numIter] = imdiffuseest(img,'ConductionMethod','quadratic');
%   img = imdiffusefilt(img,'ConductionMethod','quadratic', ...
%     'GradientThreshold',gradThresh,'NumberOfIterations',numIter);  
    img = imnlmfilt(noisyImage);
end 

%% normalize process
if (imgPreProcParam.normHist) 
  img = adapthisteq(img);
end 

%% resize process
img = imresize(img,imgPreProcParam.imgSize);

%% extend channel process
if (imgPreProcParam.extRGB) 
  img = cat(3, img, img, img);
end
output = img;
    
end
