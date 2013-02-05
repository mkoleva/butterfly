function [ result ] = multiclassify( TestSet, models, numClasses )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

result = zeros(length(TestSet(:,1)),1);

%classify test cases
for j=1:size(TestSet,1)
    for k=1:numClasses
        if(svmclassify(models(k),TestSet(j,:))) 
            break;
        end
    end
    result(j) = k;
end
end
