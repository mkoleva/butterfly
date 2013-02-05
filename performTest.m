%     'Resadm001.jpg'   1
%     'Resadm004.jpg'   
%     'Resadm005.jpg'   
%     'Resadm006.jpg'   
%     'Resadm007.jpg'   
%     'Resadm008.jpg'   
%     'Resadm009.jpg'   
%     'Resadm010.jpg'   
%     'Respea001.jpg'   9
%     'Respea002.jpg'   
%     'Respea003.jpg'
%     'Respea004.jpg'
%     'Respea005.jpg'
%     'Respea006.jpg'
%     'Respea007.jpg'
%     'Respea008.jpg'
%     'Respea009.jpg'
%     'Respea010.jpg'   18
%     'Resswa001.jpg'   19
%     'Resswa002.jpg'
%     'Resswa003.jpg'
%     'Resswa006.jpg'
%     'Resswa007.jpg'
%     'Resswa010.jpg'   25

% filenames;
% imgIndex;

newIndex = imgIndex;
% swa9 = allIDs(29,:);
% swa8 = allIDs(28,:);
% pea4 = allIDs(14,:);
% pea5 = allIDs(15,:);
% adm2 = allIDs(2,:);
% adm3 = allIDs(3,:);

trainingIDs = data;
nearestNeighborsNumber = 5;

for testm = size(data,1)-5:-10:1
    elX = data(testm,:);
    elY = data(testm-1,:);
    elXName = filenames{testm};
    elYName = filenames{testm-1};
    
    trainingIDs(testm-1:testm,:) = [];
    newIndex(testm-1:testm,:) = [];
    
    disp(strcat('Results with 4 nn for ', elXName));
    [neighbours ~]=kNearestNeighbors(trainingIDs,elX,nearestNeighborsNumber);
    for i=1:nearestNeighborsNumber
        el = neighbours(i);
        disp(newIndex{el});
    end
    disp(strcat('Results with 4 nn for', elYName));
    [neighbours ~]=kNearestNeighbors(trainingIDs,elY,nearestNeighborsNumber);
    for i=1:nearestNeighborsNumber
        el = neighbours(i);
        disp(newIndex{el});
    end
    
    
end

% allIDs(28:29,:) = [];
% allIDs(14:15,:) = [];
% allIDs(2:3,:) = [];
% 
% newIndex(29) = [];
% newIndex(28) = [];
% newIndex(15) = [];
% newIndex(14) = [];
% newIndex(3) = [];
% newIndex(2) = [];
% 
% disp('Results for swa9 with 4 nn, swa between 19-25')
% [neighbours distances]=kNearestNeighbors(allIDs,swa9,4);
% for i=1:4
%     el = neighbours(i);
%     disp(newIndex{el});
% end
% 
% disp('Results for swa8 with 4 nn,swa between 19-25')
% [neighbours distances]=kNearestNeighbors(allIDs,swa8,4);
% for i=1:4
%     el = neighbours(i);
%     disp(newIndex{el});
% end
% 
% disp('Results for pea4 with 4 nn,pea between 9-18')
% [neighbours distances]=kNearestNeighbors(allIDs,pea4,4);
% for i=1:4
%     el = neighbours(i);
%     disp(newIndex{el});
% end
% 
% disp('Results for pea5 with 4 nn,pea between 9-18')
% [neighbours distances]=kNearestNeighbors(allIDs,pea5,4);
% for i=1:4
%     el = neighbours(i);
%     disp(newIndex{el});
% end
% 
% disp('Results for adm2 with 4 nn,adm between 1-8')
% [neighbours distances]=kNearestNeighbors(allIDs,adm2,4);
% for i=1:4
%     el = neighbours(i);
%     disp(newIndex{el});
% end
% 
% disp('Results for adm3 with 4 nn,adm between 1-8')
% [neighbours distances]=kNearestNeighbors(allIDs,adm3,4);
% for i=1:4
%     el = neighbours(i);
%     disp(newIndex{el});
% end
