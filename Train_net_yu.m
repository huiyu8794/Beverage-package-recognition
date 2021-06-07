
single_Data = read_all_dataset('SingleList.txt');
double_Data = read_all_dataset('DoubleList.txt');

trainingData=[single_Data;double_Data];

% trainingData=[single_Data(1:1800,:);double_Data(1:1800,:)];
% validationData=[single_Data(1801:2462,:);double_Data(1801:2887,:)];


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
      'MaxEpochs', 10, ...
      'VerboseFrequency', 200, ...
      'CheckpointPath', tempdir);

%%
% Train detector. Training will take a few minutes.

detector = trainFasterRCNNObjectDetector(trainingData, alexnet, options)

%[bbox, score, label] = detect(detector, img);

save('net_yu.mat');
