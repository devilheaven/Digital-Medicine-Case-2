clear; close all;
rng(floor(1e6*rand())); 
%% Path 
train_path = 'dcm_resize\train';
valid_path = 'dcm_resize\valid';

%% imgPreProc options 
global imgPreProcParam; 
imgPreProcParam.en = 0;
imgPreProcParam.imgSize = [100,100];
imgPreProcParam.avgFilt = 0; 
imgPreProcParam.normHist = 0; 
imgPreProcParam.extRGB = 0; 

%% Proc options
Param.augmentedImag = 1; 


%% Create Image Datastore
imds = CT10_dcm2datastore(train_path,'.dcm',0);

%% Count Number of Images for Each Label
labelCount = countEachLabel(imds);
labelCount = labelCount.Count;
min_labelCount = min(labelCount);

%% Specify Image Size
filepath = imds.Files{1};
img = CT10_DicomPreProc(filepath);
imgsize = size(img);
if length(imgsize)==2 
    imgsize(3) = 1;
end

%% Specify Training and Validation Sets
train_ratio = 0.7;
numTrainFiles = fix(min_labelCount*train_ratio);
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% Specify Convolution Layer Parameters
filter_size = 3;
num_filters = 8;


%% augmentedImage
imageAugmenter = imageDataAugmenter( ...
    'RandRotation',[-30,30], ...
    'RandXScale',[0.8 1.2], ...
    'RandXScale',[0.8 1.2], ...
    'RandXTranslation',[-40 40], ...
    'RandYTranslation',[-40 40]); 

if (Param.augmentedImag) 
  augimdsTrain = augmentedImageDatastore(imgPreProcParam.imgSize,imdsTrain,'DataAugmentation',imageAugmenter);
  augimdsValidation = augmentedImageDatastore(imgPreProcParam.imgSize,imdsValidation,'DataAugmentation',imageAugmenter);
else 
  augimdsTrain = imdsTrain;
  augimdsValidation = imdsValidation;
end

%% Specify CNN Architechure
layers = [
    imageInputLayer(imgsize)
    
    convolution2dLayer(filter_size,num_filters,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(filter_size,num_filters*2,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(filter_size,num_filters*4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(length(labelCount))
    softmaxLayer
    classificationLayer];

%% Specify Training Options
%     'ExecutionEnvironment','parallel',...
% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...    
%     'InitialLearnRate',0.001, ...
%     'MaxEpochs',20, ...
%     'MiniBatchSize',32, ...
%     'Shuffle','every-epoch', ...
%     'ValidationData',imdsValidation, ...
%     'ValidationFrequency',10, ...
%     'Verbose',false, ...
%     'Plots', 'training-progress');
    
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',20, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',10, ...
    'Verbose',false, ...
    'Plots', 'training-progress');

%% Start Training
tic;
% [net, netinfo]= trainNetwork(augimdsTrain,layers,options);
[net, netinfo]= trainNetwork(imdsTrain,layers,options);
toc;

%% Compute Accuracy
YPred = classify(net,augimdsValidation);
YValidation = imdsValidation.Labels;
 
accuracy = sum(YPred == YValidation)/numel(YValidation);

%% Plot Confusion Matrix
plotconfusion(YValidation,YPred)

%% predict the test 
if isunix
  valid_path (strfind(valid_path,'\'))='/';
end
if (imgPreProcParam.en)
    imds_valid = imageDatastore(valid_path,'FileExtensions',file_ext,'LabelSource','foldernames','ReadFcn',@CT10_DicomPreProc);
else
    imds_valid = imageDatastore(valid_path,'FileExtensions',file_ext,'LabelSource','foldernames','ReadFcn',@dicomread);
end

if (Param.augmentedImag)
  augimds_valid = augmentedImageDatastore(imgPreProcParam.imgSize,imds_valid,'DataAugmentation',imageAugmenter);
else
  augimds_valid = imds_valid;
end 

%% generate report
imds_pre = classify(net,augimds_valid);
for n1 =1:1:150 
  [~,name,~] = fileparts(imds_valid.Files{n1});
  FileID{n1,1} = name; 
end
T = table(FileID,imds_pre,'VariableNames',{'FileID','Type'});
writetable(T,'myValid.csv','Delimiter',',') ;

% print -depsc -r1200 -tiff 
% h= findall(groot,'Type','Figure')
% h.MenuBar = 'figure';
% figure(h(1)); 
% figure(h(2)); 
% print -depsc -r1200 -tiff a.eps
% print -dpng a.png
% eval(['print -depsc -r1200 -tiff rmsfD-all', '.eps']);