cropped = cropimage(im);
maxDim = 500;
    
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
imwrite(newIm,'data/images/003_0007.png');