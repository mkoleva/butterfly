

nImages = size(filenames,1);
frequencyDistributionData = zeros(nImages,clusters);

parfor k = 1:nImages   

    I =  imread(fileNames{k});
    [mrows,ncols,m] = size(I);
    dataPixels = reshape(I,mrows*ncols,3);
    frequencyDistributionData(k,:) =  gerFreqVectorForImage( pixelData,clusterCenters);  
    
end