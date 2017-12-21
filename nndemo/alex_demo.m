%% alex_demo() uses alexnet to classify a subset of the Caltech 101 images
% as menorahs or sunflowers
% T
rng(17);


%% Set up the imagestore
% Of course, this imagestore can be used to check other classifiers.
rootFolder = '.';
categories = {'sunflower', 'menorah'};


imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
%Changee the read function in case images are too small.
% DON'T USE for gis data.
imds.ReadFcn = @(filename)readAndPreprocessImage(filename);

%There are 85 sunflowers and 87 menorahs. Let's equalize the numbers.
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2}); %This number is 85 here.
imds = splitEachLabel(imds, minSetCount, 'randomize');

%% Define the classifier

% Load pre-trained AlexNet
net = alexnet();

%Spilt training and testing images in a 70/30 split
[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');


%If there is a GPU this next part will try to use it.
featureLayer = 'fc7';
trainingFeatures = activations(net, trainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainingFeatures, trainingSet.Labels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');


%% Evaluate the classifer

testFeatures = activations(net, testSet, featureLayer);
predictedLabels = predict(classifier, testFeatures);
%The confusion matrix is diagonal. The classifier distinguishes sunflowerer
% and menorahs just fine.

confusionmat(testSet.Labels, predictedLabels)

