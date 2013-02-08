function [croppedim ] = cropimage( im)
% Crop image to bounding box of butterfly
%
%Given an image, crop the butterfly based on extreme points

[top_col, top_row]= find(sum(im,3)', 1);
[bottom_col, bottom_row]= find(sum(im,3)', 1, 'last');
[left_row, left_col]= find(sum(im,3), 1);
[right_row, right_col]= find(sum(im,3), 1, 'last');

croppedim = imcrop(im, [left_col top_row  right_col-left_col bottom_row-top_row ]);


end

