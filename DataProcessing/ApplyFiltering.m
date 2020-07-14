%-------------------------------------------------------------------------------
% FILTERING
%-------------------------------------------------------------------------------
% get the proportion of NaN genes of each voxel
propNanGenes = sum(isnan(voxGeneMat),2)/size(voxGeneMat,2);
% index of genes that are not nan in at least a reasonable proportion of voxels
isGoodGene = (sum(isnan(voxGeneMat),1) < procParams.whatGeneThreshold*numVoxels);

%% only keep good voxels
isGoodVoxel = (sum(isnan(voxGeneMat),2) < procParams.whatVoxelThreshold*numGenes);
voxGeneMat = voxGeneMat(isGoodVoxel,:);

%% normalize matrix
voxGeneMat = BF_NormalizeMatrix(voxGeneMat,procParams.whatNorm); % 'scaledSigmoid' used in Monash analysis

% only keep good voxels
coOrds = coOrds(isGoodVoxel,:);
