function [distances_all,corrCoeff_all]=computeCorrCoeffAll_distancesAll(voxGeneMat,dataIndSelect,distMat)
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff_all=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances_all = extractDistances(distMat);
end
