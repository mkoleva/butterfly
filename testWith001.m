% Load image
  I=imread('swa017.jpg');
% Set this option to true if you want to see more information
  Options.verbose=false; 
% Get the Key Points
  Ipts=OpenSurf(I,Options);
% Draw points on the image
  PaintSURF(I, Ipts);