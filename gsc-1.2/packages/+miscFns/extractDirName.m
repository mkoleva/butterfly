function annoName=extractDirName(fullImgName)
% Function to extract the last directory name from the full path
% Usage:
%  dirName=extractDirname(fullPath)
%
  fullImgName(fullImgName=='\')='/';
  if(fullImgName(end)=='/'), fullImgName=fullImgName(1:end-1); end;
  [slashes]=regexp(fullImgName,'/');
  if(isempty(slashes)) lastSlash=0;
  else lastSlash=slashes(end);
  end;

  annoName=fullImgName(lastSlash+1:end);
