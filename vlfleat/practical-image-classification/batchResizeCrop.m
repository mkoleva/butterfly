function [] = batchResizeCrop( filenames, maxDim)
%Batch resize function to resize images with maximum dimension maxDim
% and crop them to the boudning box of the single connected component
%
% Read dir is /data/unprocessed
% Write dir is /data/images
%
nImages = length(filenames);

parfor (i = 1:nImages)
    I = imread(['data/unprocessed/' filenames{i}]);
    %crop image
    cropped = cropimage(I);
    
    %get size and check if resizing is needed
    [rows,cols,~] = size(cropped);
    bigger = max(rows,cols);
    if maxDim<bigger
        scale = maxDim/bigger;
    else
        scale = 1;
    end
    
    %resize and write back
    newIm = imresize(cropped,scale);
    %newname = regexprep(filenames{i}, '_seg', '');
    imwrite(newIm,['data/images/' filenames{i}]);
end


end

