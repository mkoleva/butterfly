function resizephotos(directory, wh, isrecursive, isoverwrite, savetopath, supportFormat)
% resizephotos: resize a batch of photos
%
% resizephotos -dir max_width_and_height, will let you choose a directory, 
% and resize all the photos in the directory. When max_width_and_height is 
% omitted, it uses 1600 by default(1600px is enough for most monitors).
% 
% resizephotos -files max_width_and_height, will let you choose some files,
% and resize all the files in the directory.
% 
% You might be asked for whether to recursively resize all the photos in
% subdirectories.
% 
% and You might be asked for whether to overwrite the original files. If
% you choose 'No', the program will save the resized images in new 
% directories or files with prefix 'resize-'.
% 
% resizephotos(file_or_directory, max_width_and_height, is_recursive, ...
% is_overwrite, path_to_save): you can use the function by specifying
% the path of the directories and files. When using this method, you can 
% specific the max width and height of the resized photos. When path_to_save 
% is omitted, the path to save the resized photos will generated automatically 
% depends on is_overwrite parameter.
% 
% 
% See also imresize
% 
% Copyright 2010, zhiqiang.org
% author: zhang@zhiqiang.org, url:
% http://zhiqiang.org/blog/it/batch-resize-images-using-matlab.html
%   $Revision: 1.1.6.28.2.1 $  $Date: 2009/01/27 04:47:43 $

%% cope with the input parameters
% if the directory is not set, we open a file select dialog for use to
% select the files or path to deal with
if nargin == 0 || (nargin >= 1 && ischar(directory) && strcmp(directory, '-dir')) %
    directory = uigetdir;
    % let user to choose whether recursively resize all the subdirectories
    tmp = questdlg('Did you want to recursively resize all the subdirectories?');
    if strcmp('Yes', tmp)
        isrecursive = true;
    else strcmp('No', tmp)
        isrecursive = false;
    end    
    isoverwrite = askforoverwrite();
elseif nargin == 0 || (nargin >= 1 && ischar(directory) && strcmp(directory, '-files'))
    [p, f] = uigetfile({'*.*;', 'All files'}, 'MultiSelect', 'on');
    if isnumeric(p) && ~p
        return;
    end
    
    directory = cell(size(p));
    if numel(p) > 1
        directory{1} = [f, p];
    else
        for i = 1:numel(p)
            directory{i} = [f, p{i}];
        end  
    end
    isoverwrite = askforoverwrite();
end

% set other parameters
if ~exist('wh', 'var'), wh = 1600; elseif ischar(wh), wh = eval(wh); end
if ~exist('isrecursive', 'var'), isrecursive = false; end
if ~exist('isoverwrite', 'var'), isoverwrite = false; end
if ~exist('savetopath', 'var'), savetopath = []; end
if nargin <= 5 || isempty(supportFormat), supportFormat = '*'; end

%% mult-files
% if directory is a cell, it indicate multi-files or multi-directories,
% we resize them one by one

if iscell(directory)
    for i = 1:numel(directory)
        resizephotos(directory{i}, wh, isrecursive, isoverwrite, savetopath, supportFormat);
    end
    return;
end

%% if everything are OK

if exist(directory, 'file') &&  ~isdir(directory) % for a file, 
    if nargin <= 4 || isempty(savetopath)
        if isoverwrite
            savetopath = directory;
        else
            [pd, fd] = lastdirectory(directory);
            savetopath = [pd, 'resize-', fd];
        end        
    end
    resizesinglephoto(directory, wh, savetopath);
elseif isdir(directory) % if directory is a real directory
    % the last char of directory should be a '\'
    if directory(end) ~= '\'
        directory = [directory, '\'];
    end
    % generate the saved directory
    if nargin <= 4 || isempty(savetopath) % when at the first recursive and savetopath is not set
        % we need to generate the saved directory
        if isoverwrite
            savetopath = directory;
        elseif ~isoverwrite
            [savetopath, lastd] = lastdirectory(directory);
            savetopath = [savetopath, 'resize', lastd, '\'];
        end
        % when the savetopath do not exist, we create one
        if ~isdir(savetopath)
            mkdir(savetopath);
        end
    end
    
    % now we resize all photos in current directory, and recursive resize
    % all the directories if needed
    allfiles = dir(directory);
    
    % before we generate now image file, we first make sure the savetopath
    % exists, otherwise generate it.
    if ~isdir(savetopath)
        mkdir(savetopath);
    end
    for i = 1:numel(allfiles)
        cur = allfiles(i).name;
        % ignore the path '.' and '..'
        if numel(cur) > 2 || ~min(cur == '.')
            if allfiles(i).isdir && isrecursive
                resizephotos([directory cur '\'], wh, isrecursive, isoverwrite, ...
                    [savetopath cur '\'], supportFormat);
            elseif ~allfiles(i).isdir
                resizesinglephoto([directory cur], wh, [savetopath cur]);
            end
        end
    end 
end

%% resize single photo, save it to savetopath
function resizesinglephoto(photo, wh, savetopath)

try
    I = imread(photo);
catch ME %#ok<NASGU>
    % disp(ME.message);
    disp(['!!! ' photo ' is not recognized as an image file, and it''s ignored']);
    return;
end
    
% [w, h] is the width and height of original graph
w = size(I, 1);
h = size(I, 2);

% 获取resize后的大小 [maxw, maxh]
if numel(wh) == 1
    if w > h
        maxw = wh;
        maxh = wh*h/w;
    else
        maxh = wh;
        maxw = wh*w/h;
    end
else
    maxw = wh(1);
    maxh = wh(2);
    if (w-h)*(maxw-maxh) < 0
        [maxw, maxh] = deal(h, w);
    end
    
    if w/h < maxw/maxh
        maxw = maxh*w/h;
    else
        maxh = maxw*h/w;
    end
end

if maxw < w
    I = imresize(I, [maxw, maxh]);
end
imwrite(I, savetopath);
disp([photo ' is resized, and is saved to ' savetopath]);

%% lastdirectory 
function [pd, ld] = lastdirectory(d)
% return the last directory, for example, lastdirectory('\abc\edf\') =
% ['\abc\','edf']. When d is a file, return the path and the file name, i.e
% lastdirectory('abc\def\x.jpg') = ['abc\def\', 'x.jpg']


% remove the last \
if isdir(d) && d(end) == '\'
    d = d(1:end-1);
end

% if there is a \
if max(d=='\')
    ld = d(find(d=='\', 1, 'last')+1:end);
else
    ld = d;
end

pd = d(1:end-numel(ld));

%% ask for whether to overwrite original files
function isoverwrite = askforoverwrite()
tmp = questdlg(['Did you want to overwrite the original files? ' ...
        'if you choose No, we will add a ''resize'' prefix to your ' ...
        'files or directories.']);
if strcmp('Yes', tmp)
    isoverwrite = true;
elseif strcmp('No', tmp)
    isoverwrite = false;
end