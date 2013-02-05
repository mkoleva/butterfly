filenames = readFileNames('Resadm01.png');
nPictures = size(filenames);
nPictures = nPictures(:,1);

allimages = zeros(nPictures,1);
imgIndex = cell(nPictures,1);

classes = {'Resadm','Respea','Resswa','Reszeb','Resmch'};
for i=1:nPictures
    [numrows,numcols,~] =size(imread(filenames{i}));
    disp(filenames{i});

    %allimages(i,:) = cls_id(i,:);
    for j=1:5
        if  strncmpi(classes{j},filenames{i},6)
            imgIndex{i} = classes{j};
        end
    end
    
end
