%
%This script runs an experiment on 5 classes. It reads the histogram data
%for each class. Then it adds the histograms and names to histograms and
%labels variables. This builds the training data, i.e.
%       TRAINING DATA: histograms : histograms per training image k*n, n
%       #images
%                      labels :     the labels of the training images 1*n

% Similarly the testing data is read from the _val files and stored in
% testNames, testHistograms and testLabels.
%
% Training phase: pass all histograms and labels and build classNum models
% with OVA method, i.e. for each class, the class label is 1 and all others
% are class 0.
% Pass these models with the classNum to multiclassify - >
%
%

classNum = 10;
i=1;
histograms = [];
labels = [];
testHistograms = [];
testLabels = [];
testNames = [];

for subset = {'admiral', ...
              'machaon', ...
              'peacock', ...
              'swallowtail', ...
              'zebra', ...
              'cabbagewhite', ...
              'buckeye', ...
              'mourningcloak', ...
              'paintedlady', ...
              'longwing'}
  fprintf('Processing %s\n', char(subset)) ;
  
  pos{i} = load(fullfile('data', [char(subset) '_hist.mat']));
  i=i+1;
end

for i=1:classNum
   
   names{i}=pos{i}.names{:}; 
   histograms = [histograms,pos{i}.histograms];
   labels = [labels,i-1+ones(1,numel(pos{i}.names))];
end
clear pos;

%
%--------------------------Testing data---------------------------
%-----------------------------------------------------------------
% i=1;
% for subset = {'admiral_val', ...
%               'machaon_val', ...
%               'peacock_val', ...
%               'swallowtail_val', ...
%               'zebra_val'}
%   fprintf('Processing %s\n', char(subset)) ;
%   
%   pos{i} = load(fullfile('data', [char(subset) '_hist.mat']));
%   i=i+1;
% end
% for i=1:classNum
% 
%    testNames{i}=pos{i}.names{:};
%    testHistograms = [testHistograms,pos{i}.histograms];
%    testLabels = [testLabels,i-1+ones(1,numel(pos{i}.names))];
% end
% 
% clear pos

% %-------------------Display counts-----------------------
u=unique(labels);
numClasses=length(u);

u=unique(testLabels);
numTestClasses=length(u);
% count how many images are there
fprintf('number of training images: %d images, %d classes\n', ...
        size(labels,2), numClasses) ;
% fprintf('Number of testing images: %d images, %d classes\n', ...
%         size(testLabels,2),numTestClasses) ;
% 
% 
% %--------------------Normalize-------------
% %----------------------L2

histograms = bsxfun(@times, histograms, 1./sqrt(sum(histograms.^2,1))) ;
testHistograms = bsxfun(@times, testHistograms, 1./sqrt(sum(testHistograms.^2,1))) ;
 

% %-------------------------------SVM-----------------------
% 
% [models, numClasses] = multisvm1(double(histograms'),labels');
% [result] = multiclassify( testHistograms', models, numClasses );
% 
% %WHAT IS RESULTS???
% 
% 
% % Visualize the ranked list of images
% %figure(1) ; clf ; set(1,'name','Ranked training images (subset)') ;
% %displayRankedImageList(names, result)  ;
% 
% % Visualize the precision-recall curve
% % ----but have to do it for each class individually
% %figure(2) ; clf ; set(2,'name','Precision-recall on train data') ;
% %vl_pr(testLabels', result) ;
% 
% labelsCopy = testLabels';
% resultsCopy = result;
% 
% accuracy = testLabels'-result;
% errors = sum(accuracy~=0);
% fprintf('Accuracy %d/%d\n', size(accuracy,1)-errors, size(accuracy,1));
% fprintf('Result: %3.3f%%\n', 100*(size(accuracy,1)-errors)/size(accuracy,1));


%----------------------CV------------------------------------------------
%------------------------------------------------------------------------

% Create a 10-fold cross-validation to compute classification error.

     indices = crossvalind('Kfold',labels',10);
     cp = classperf(labels');
     objects = histograms';
     species = labels';
     for i = 1:10
         test = (indices == i); train = ~test;
         
         [models, numClasses] = multisvm1(objects(train,:),species(train,:));
         class = multiclassify( objects(test,:), models, numClasses );
         
         classperf(cp,class,test);
     end
    
     cp.CorrectRate

% for class=1:numClasses
%    testLabels = labelsCopy';
%    result = resultsCopy;
%    fprintf('Class num');
%    class
%    testLabels'
%    
%    result(result~=class)=-10;
%    testLabels(testLabels~=class)=-1;
%    figure(2) ; clf ; set(2,'name','Precision-recall on train data') ;
%     vl_pr(testLabels', result) ;
%        fprintf('Class num');
%    class
%    testLabels'
%     
% end




