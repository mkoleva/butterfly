% EXERCISE2: learn your own model

% add required search paths
setup ;

% --------------------------------------------------------------------
% Stage A: Data Preparation
% --------------------------------------------------------------------

vocabulary = load('data/vocabulary.mat') ;

% Compute positive histograms from your own images
pos.names = getImageSet('data/myImages') ;
pos.histograms = computeHistogramsFromImageList(vocabulary, pos.names, 'data/cache') ;

% Add default background images
neg = load('data/background_train_hist.mat') ;
names = {pos.names{:}, neg.names{:}};
histograms = [pos.histograms, neg.histograms] ;
labels = [ones(1,numel(pos.names)), - ones(1,numel(neg.names))] ;
clear pos neg ;

% Load testing data
pos = load('data/horse_val_hist.mat') ;
%pos = load('data/car_val_hist.mat') ;
neg = load('data/background_val_hist.mat') ;
testNames = {pos.names{:}, neg.names{:}};
testHistograms = [pos.histograms, neg.histograms] ;
testLabels = [ones(1,numel(pos.names)), - ones(1,numel(neg.names))] ;
clear pos neg ;

% count how many images are there
fprintf('Number of training images: %d positive, %d negative\n', ...
        sum(labels > 0), sum(labels < 0)) ;
fprintf('Number of testing images: %d positive, %d negative\n', ...
        sum(testLabels > 0), sum(testLabels < 0)) ;

% Hellinger's kernel (histograms are l1 normalized)
histograms = sqrt(histograms) ;
testHistograms = sqrt(testHistograms) ;

% --------------------------------------------------------------------
% Stage B: Training a classifier
% --------------------------------------------------------------------

% Train the linear SVM
C = 100 ;
[w, bias] = trainLinearSVM(histograms, labels, C) ;

% Evaluate the scores on the training data
scores = w' * histograms + bias ;

% Visualize the ranked list of images
% figure(1) ; clf ; set(1,'name','Ranked training images (subset)') ;
% displayRankedImageList(names, scores)  ;

% Visualize the precision-recall curve
% figure(2) ; clf ; set(2,'name','Precision-recall on train data') ;
% vl_pr(labels, scores) ;

% --------------------------------------------------------------------
% Stage C: Classify the test images and assess the performance
% --------------------------------------------------------------------

% Test the linar SVM
testScores = w' * testHistograms + bias ;

% Visualize the ranked list of images
figure(3) ; clf ; set(3,'name','Ranked test images (subset)') ;
displayRankedImageList(testNames, testScores)  ;

% Visualize the precision-recall curve
figure(4) ; clf ; set(4,'name','Precision-recall on test data') ;
vl_pr(testLabels, testScores) ;


% Print results
[drop,drop,info] = vl_pr(testLabels, testScores) ;
fprintf('Test AP: %.2f\n', info.auc) ;

[drop,perm] = sort(testScores,'descend') ;
fprintf('Correctly retrieved in the top 36: %d\n', sum(testLabels(perm(1:36)) > 0)) ;


