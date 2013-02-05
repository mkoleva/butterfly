I = imread(fileNames{k});
[mrows,ncols,m] = size(I);
segmentedCellSequence(k,1:mrows*ncols,:) = reshape(I,mrows*ncols,3); 
k = segmentedCellSequence(:,pixelID,:);