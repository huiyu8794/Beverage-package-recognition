
%% Train Faster R-CNN Vehicle Detector

%%
% Load training data.
% % trainingData = read_all_dataset('SingleList.txt')
% data = load('fasterRCNNVehicleTrainingData.mat');
% % % 
% trainingData = data.vehicleTrainingData
% 
% trainingData.imageFilename = fullfile(toolboxdir('vision'),'visiondata', ...
%     trainingData.imageFilename)
data = load('net2.mat');
load('net2.mat' , 'lgraph');
trainingData = read_all_dataset('AllList.txt');
% trainingData.imageFilename = fullfile('C:\Users\Lai Hao Wei\Documents\MATLAB', ...
%     trainingData.imageFilename);

%%
% Setup network layers.
% lgraph = data.lgraph;
% layers2 = data2.layers

%%
% Configure training options.
%
% * Lower the InitialLearnRate to reduce the rate at which network
%   parameters are changed.
% * Set the CheckpointPath to save detector checkpoints to a temporary
%   directory. Change this to another location if required.
% * Set MaxEpochs to 1 to reduce example training time. Increase this
%   to 10 for proper training.
 options = trainingOptions('sgdm', ...
      'MiniBatchSize', 1, ...
      'InitialLearnRate', 1e-3, ...
      'MaxEpochs', 5, ...
      'VerboseFrequency', 200, ...
      'CheckpointPath', tempdir);

%%
% Train detector. Training will take a few minutes.
detector = trainFasterRCNNObjectDetector(trainingData, lgraph, options)

%%
% Test the Fast R-CNN detector on a test image.
img = imread('B1_IMG_0404.jpg');

%%
% Run detector.
[bbox, score, label] = detect(detector, img);

%%
% Display detection results.
detectedImg = insertShape(img, 'Rectangle', bbox);
figure
imshow(detectedImg)