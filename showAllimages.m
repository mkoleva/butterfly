nImages = length(filenames);
maxDim = 500;

for i=1:nImages
   croppedIm = getOnlyShape(filenames{i});
   [rows,cols,d] = size(croppedIm);

    bigger = max(rows,cols);
    if maxDim<bigger
        scale = maxDim/bigger;
    else
        scale = 1;
    end


    newIm = imresize(croppedIm,scale);
   
   
   
   imwrite(newIm,strcat('Res',filenames{i}));
   
end