function [distances,corrCoeff,angle_coronal,angle_axial,angle_sagittal]=sampleGridData(...
                                                                        voxGeneMat,...
                                                                        coOrds,...
                                                                        whatNumData,...
                                                                        timePointNow,...
                                                                        scaledDistance)
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
  if scaledDistance
    distances=extractDistances(distMat)/max(extractDistances(distMat));
  else
    distances=extractDistances(distMat);
  end
  % determine directionality
  [angle_coronal,angle_axial,angle_sagittal]=makeDirectionality(coOrds(dataIndSelect,:));
  angle_coronal=extractDistances(squareform(angle_coronal));
  angle_axial=extractDistances(squareform(angle_axial));
  angle_sagittal=extractDistances(squareform(angle_sagittal));
  % annotation_grid=annotation_grid(dataIndSelect);
  % pairsIx=cell(length(corrCoeff),1);
  % annotation_pair=cell(length(corrCoeff),1);
  % for j=1:length(corrCoeff)
  %     [iq,ir]=ind2sub4up(j);
  %     pairsIx{j}=[iq,ir];
  %     annotation_pair{j}=annotation_grid(pairsIx{j});
  % end
end
