function [ result ] = multiclassifyWithRandom( TestSet, models, numClasses )
%multiclassify: provided with a testset, a set of models and the num of
%class, perform a OVA svm classification, where the svmclassify function is
%called iteratively with every model. If a match is found return. -
%WARNING: This would be biased towards the order of the class (not happy).
%   

result = zeros(length(TestSet(:,1)),1);
positive = [];

%classify test cases, we have j test samples
for j=1:size(TestSet,1)
    for k=1:numClasses
        if(svmclassify(models(k),TestSet(j,:)))
            positive(end+1) = k;
        end
    end
    if size(positive,2)==0
        result(j)= -1;
    elseif size(positive,2) == 1
        result(j) = positive(1);
        
    else
        index = randi(size(positive,2),1);
        result(j) = positive(index);
    end
    positive = [];
end
end

