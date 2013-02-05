function [ pixels, cls_id,cls_c ] = getClustersForImage( fileName, clustNum )
%Give a filename and clustNum, the function imports the image and builds
% clustNum amount of clusters
%   output: TODO

originalImage = im2double(imread(fileName));
[mrows,ncols,m] = size(originalImage);
pixels = reshape(originalImage,mrows*ncols,3);
size(pixels)
opts = statset('Display','final','MaxIter',150);
    
[cls_id,cls_c] = kmeans(pixels,clustNum,'Replicates',3, 'Options',opts);


end

