function [distances,corrCoeff]=sampleGridData(voxGeneMat,coOrds,whatNumData,timePointNow)
  % Create distance matrix from only voxels selected for gene expression matrix
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  resolutionGrid=struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,...
      'P14',200,'P28',200);
  timePointIndex=find(cellfun(@(c)strcmp(timePointNow,c),timePoints));
  [dataIndSelect,~]=datasample([1:size(voxGeneMat,1)],whatNumData,'replace',false);
  distMat=squareform(pdist(coOrds(dataIndSelect,:),...
                        'euclidean')*resolutionGrid.(timePoints{timePointIndex}));
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances=extractDistances(distMat);
end
