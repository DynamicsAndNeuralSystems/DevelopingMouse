function [distances,corrCoeff]=sampleGridData(voxGeneMat,coOrds,whatNumData)
  % Create distance matrix from only voxels selected for gene expression matrix
  [dataIndSelect,~]=datasample([1:size(voxGeneMat,1)],whatNumData,'replace',false);
  distMat=squareform(pdist(coOrds(dataIndSelect,:),...
                        'euclidean')*resolutionGrid.(timePoints{timePointIndex}));
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances=extractDistances(distMat);
end
