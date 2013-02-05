function I = imreadbw(file) 
% IMREADBW  Reads an image as gray-scale
%   I=IMREADBW(FILE) reads the image FILE and converts the result to a
%   gray scale image (with DOUBLE storage class anr range normalized
%   in [0,1]).

I=im2double(imread(file)) ;

if(size(I,3) > 1)
  I = rgb2gray( I ) ;
end


