function [orig]=getOnlyShape( filename )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


im = imread(filename);
redIm = im(:,:,1);
gIm = im(:,:,2);
blueCh = im(:,:,3);
blueIm  = blueCh;
%all max blue are forced to 0 (most likely bg)
blueCh((blueCh(:,:)==255))=0;




mask = ones(size(blueCh));
blueCh = blueCh & mask;
blueCh = imfill(blueCh, 'holes');


%Label the connected components using the blue channel
labeledImage = bwlabel(blueCh, 8);
ZZ = bwconncomp(blueCh);

%Select blobs with area>200 ana delete all others from the image
numPixels = cellfun(@numel,ZZ.PixelIdxList);
smallerBlobs = numPixels<200;
numPixels = immultiply(numPixels,smallerBlobs);
toDelete = find(numPixels);
deleteBlobsImage = ismember(labeledImage, toDelete);
blueCh(deleteBlobsImage)=0;


zz2 = bwconncomp(blueCh);
bounding = regionprops(zz2);

redCh = immultiply(redIm,blueCh);
greenCh = immultiply( gIm,blueCh);
blueIm = immultiply(blueIm, blueCh);

orig  = cat(3,redCh,greenCh,blueIm);
orig = imcrop(orig, bounding(1).BoundingBox);


% 
% 



end

