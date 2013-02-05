function [freqVector] = gerFreqVectorForImage( pixelData,clusterCenters)
%Plots clusters with different colour for each cluster
    
    %pixelData = #images x pixelsInImage x xyz
    
    neighborIds = zeros(size(pixelData,1),1);
    neighborDistances = neighborIds;

    %number of clusters
    clusters = size(clusterCenters,1);
    freqVector = zeros(clusters,1);

    col = hsv(clusters);
    dataVectors = size(pixelData,1);
    
    parfor i=1:dataVectors
        dist = sum((repmat(pixelData(i,:),clusters,1)-clusterCenters).^2,2);
        [sortdist sortpos] = sort(dist,'ascend');
        neighborIds(i) = sortpos(1);
        %neighborDistances(i,:) = sqrt(sortval(1:k));
    end
    vectorLen = size(neighborIds,1);
    for j = 1:clusters
        freqVector(j) = size(neighborIds(neighborIds==j),1);
        freqVector(j) = freqVector(j)/vectorLen;
    end
 
%     for i=1:50000
%         
%         clusterNumber = neighborIds(i,1);
%         plot3(data(i,1),data(i,2),data(i,3),'color',col(clusterNumber,:));
%         hold on
%         
%     end

end

