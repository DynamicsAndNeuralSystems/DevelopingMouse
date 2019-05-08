function [distMat,cgeMat] = makeSpatialMat(voxGeneMat,coOrds,whatNumData,timePointNow)
  timePoints = GiveMeParameter('timePoints');
  resolutionGrid=GiveMeParameter('resolutionGrid');
  timePointIndex=find(strcmp(timePointNow,timePoints));
  [dataIndSelect,~] = datasample([1:size(voxGeneMat,1)],whatNumData,'replace',false);
  distMat=squareform(pdist(coOrds(dataIndSelect,:),...
                        'euclidean')*resolutionGrid.(timePoints{timePointIndex}));
  cgeMat=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
end
