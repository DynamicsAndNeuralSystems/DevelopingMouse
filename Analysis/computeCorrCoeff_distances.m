function [distances,corrCoeff]=computeCorrCoeff_distances(voxGeneMat,distMat,dataIndSelect)
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances=extractDistances(distMat);
end
