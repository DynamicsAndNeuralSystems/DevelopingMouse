function [distances,corrCoeff,angle_coronal,angle_axial,angle_sagittal]=sampleGridData(voxGeneMat,coOrds,whatNumData,timePointNow,scaledDistance,withDirection)
  % Create distance matrix from only voxels selected for gene expression matrix
  timePoints = GiveMeParameter('timePoints');
  resolutionGrid=GiveMeParameter('resolutionGrid');
  timePointIndex=find(strcmp(timePointNow,timePoints));
  [dataIndSelect,~] = datasample([1:size(voxGeneMat,1)],whatNumData,'replace',false);
  distMat = squareform(pdist(coOrds(dataIndSelect,:),...
                        'euclidean')*resolutionGrid.(timePoints{timePointIndex}));
  % extract the correlation coefficients
  geneCorr = corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff = extractDistances(geneCorr);
  % extract distances from distance matrix
  if scaledDistance
    distances = extractDistances(distMat)/max(extractDistances(distMat));
  else
    distances = extractDistances(distMat);
  end
  if withDirection
    % shuffle the distances and corrCoeff
    shuffledOrder = randperm(whatNumData);
    distances = distances(shuffledOrder);
    corrCoeff = corrCoeff(shuffledOrder);
    % determine directionality
    [angle_coronal,angle_axial,angle_sagittal]=makeDirectionality(coOrds(dataIndSelect,:),...
                                                                  shuffledOrder);
    % angle_coronal=extractDistances(squareform(angle_coronal));
    % angle_axial=extractDistances(squareform(angle_axial));
    % angle_sagittal=extractDistances(squareform(angle_sagittal));
  else
    angle_coronal=NaN;
    angle_axial=NaN;
    angle_sagittal=NaN;
  end
end
