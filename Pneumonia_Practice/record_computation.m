%% Read Image Data
img = dicomread('00a85be6-6eb0-421d-8acf-ff2dc0007e8a.dcm');
imshow(img)

%% Show 20 Random Images
files = dir('*.dcm');
figure;
perm = randperm(1000,20);
for i = 1:20
    subplot(4,5,i);
    img = dicomread(files(perm(i)).name);
    imshow(img);
end

%% Check Image Size
img = dicomread('00a85be6-6eb0-421d-8acf-ff2dc0007e8a.dcm');
imgsize = size(img);

%% Create Image Datastore
imds = dcm2datastore(pwd,'.dcm',0);

%% Count Number of Images for Each Label
labelCount = countEachLabel(imds);
labelCount = labelCount.Count;
min_labelCount = min(labelCount);

%% Specify Image Size
filepath = imds.Files{1};
img = dicompreprocess(filepath);
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
[net netinfo]= trainNetwork(imdsTrain,layers,options);
toc;

%% Compute Accuracy
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
 
accuracy = sum(YPred == YValidation)/numel(YValidation);

%% Plot Confusion Matrix
plotconfusion(YValidation,YPred)

%% Transfer Learning

%% Load Pretrained Network
net = alexnet;

%% Analyze Pretrained Network
analyzeNetwork(net)

%% Check Input Image Size
inputSize = net.Layers(1).InputSize

%% Prepare Data
imds = dcm2datastore(pwd,'.dcm',0);
labelCount = countEachLabel(imds);
labelCount = labelCount.Count;
min_labelCount = min(labelCount);
train_ratio = 0.7;
numTrainFiles = fix(min_labelCount*train_ratio);
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% Replace Final Layers
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(imdsTrain.Labels))

layers = [
   layersTransfer
   fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
   softmaxLayer
   classificationLayer];

%% Specify Training Options
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

%% Start Training Transfer Network
tic;
netTransfer = trainNetwork(imdsTrain,layers,options);
toc;

%% DeepNetworkDesigner
deepNetworkDesigner
