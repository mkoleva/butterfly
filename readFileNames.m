function fileNames = readFileNames(filename)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
p = which(filename);
filelist = dir([fileparts(p) filesep 'Res*.png']);
fileNames = {filelist.name}';

end

