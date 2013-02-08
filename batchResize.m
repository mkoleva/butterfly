function [] = batchResize( filenames, maxDim)
%Batch resize function to resize images with maximum dimension maxDim
nImages = length(filenames);

parfor (i = 1:nImages)
    I = imread(filenames{i});
    [rows,cols,~] = size(I);

    bigger = max(rows,cols);
    if maxDim<bigger
        scale = maxDim/bigger;
    else
        scale = 1;
    end


    newIm = imresize(I,scale);
    imwrite(newIm,strcat('Res',filenames{i}));
end


end

