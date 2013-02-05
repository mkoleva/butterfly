function [frequencyDistributionData,cls_id, cls_c] = buildFromImages( fileNames, clusterNumber,sampleSize )
%Build clusters for images
%       input: filename
%       output: data, clusted id and cluster centers

maxSize = 500;
nImages = length(fileNames);
opts = statset('Display','final','MaxIter',100,'UseParallel','always');

segmentedCellSequence = zeros(nImages,maxSize*maxSize,3);

for k = 1:nImages   

    I =   imread(fileNames{k});
    [mrows,ncols,m] = size(I);
    segmentedCellSequence(k,1:mrows*ncols,:) = reshape(I,mrows*ncols,3);    
    
end


transformed = reshape(segmentedCellSequence,k*maxSize*maxSize,3);
size(transformed)
transformed(all(transformed==0,2),:)=[];
size(transformed)
transformed = unique(transformed,'rows');
size(transformed)
transformed = transformed(randperm(sampleSize),:);
size(transformed)


[cls_id,cls_c] = kmeans(transformed,clusterNumber,'Replicates',5,'Options',opts);
clusters = size(cls_c,1);
frequencyDistributionData = zeros(nImages,clusters);

%Use parfor instead
parfor k = 1:nImages   
    
    dataPixels = reshape(segmentedCellSequence(k,:,:),maxSize*maxSize,3);
    dataPixels(all(dataPixels==0,2),:)=[];
    
    frequencyDistributionData(k,:) =  gerFreqVectorForImage( dataPixels,cls_c);  
    
end

% 
% 
% parfor pixel=pixelID+1:pixelID+2000
%     k = segmentedCellSequence(:,pixel,:);
% 
%     [rows,~,pi] = size(k);
%     transformed = reshape(k,rows,3);
%     %transformed(all(transformed==0,2),:)=[];
% 
%     [cls_id,~] = kmeans(transformed,20,'Replicates',5,'Options',opts);
%     allClassID(:,pixel-pixelID) = cls_id;
%     segmentedCellSequence(:,pixel,:) = zeros(rows,1,pi);
% end
% 
% for k = 1:nImages   
% 
%     I = imread(fileNames{k});
%     [mrows,ncols,m] = size(I);
%     Z = segmentedCellSequence(k,1:mrows*ncols,:);
%     I= reshape(Z,mrows,ncols,3); 
%     imwrite(I,strcat('Read',fileNames{k}));
%     
% end


end

