% Match segmentations with a photo from segNames and imageNames
%
%Format name_mask.png => name.jpg
%
IMAGE_DIR = 'leedsbutterfly/newim/';
cd leedsbutterfly/newim/
images = dir('*.jpg');


for i=1:size(images,1)
   
    [pt,name,ext] = fileparts( images(i).name);
    image = imread(images(i).name);
    mask = imread(['../segs/' name '-seg.png']);
    mask(mask~=0)=1;
    mask = imresize(mask, [size(image,1) size(image,2)]);
    
    filled_mask = imfill(mask, 'holes');  
    segmentedImage = image.*repmat(filled_mask,[1,1,3]);
    
    %To view uncomment
    %imshow(segmentedImage);
    %pause
    
    
    imwrite(segmentedImage,['../photos/' name '.png'],'png');
    
    
end
cd ../..