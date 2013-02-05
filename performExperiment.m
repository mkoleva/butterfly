%Perform a full experiment
%
% Arguments:    k : number of clusters
%               m : number of nearest-neighbours used
%               n : number of samples used for clustering
%               isHSV : are hsv values used or RGB
%

k = 200;
sampleSize = 1000;

filenames = readFileNames('adm011.jpg');
[data,idx, c] = buildFromImages( filenames,k, sampleSize );
doALL();

performTest();

