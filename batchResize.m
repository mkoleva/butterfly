function [] = batchResize( filenames, maxDim)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nImages = length(filenames);

parfor (i = 1:nImages)
    I = imread(filenames{i});
    [rows,cols,d] = size(I);

    bigger = max(rows,cols);
    if maxDim<bigger
        scale = maxDim/bigger
    else
        scale = 1;
    end


    newIm = imresize(I,scale);
    imwrite(newIm,strcat('Res',filenames{i}));
end


end

