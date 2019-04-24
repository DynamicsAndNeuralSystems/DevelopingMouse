timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% create correlation coefficient and distance matrix for all voxels in all times points
load('voxelGeneCoexpression_all.mat')
% initialize
voxelGeneCoexpression_all_allVoxels=struct();
for i=1:length(timePoints)
  % collect the voxgeneMat
  voxelGeneCoexpression_all_allVoxels.wholeBrain.voxGeneMat_all{i}=...
                                          voxelGeneCoexpression_all.wholeBrain.voxGeneMat_all{i};
  % compute correlation coefficients
  
