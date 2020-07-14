function [voxGeneMat, coOrds, propNanGenes, isGoodGene] = makeGridData(timePointNow,procParams)

% Creates a voxel x gene matrix with irrelevant voxels filtered out
%% Sets background variables
sizeGrids = GiveMeParameter('sizeGrids');
timePoints = GiveMeParameter('timePoints');
resolutionGrid = GiveMeParameter('resolutionGrid');
timePointIndex = find(strcmp(timePointNow,timePoints)); %match index to the chosen timepoint

%% load matlab variables
cellTypeStr = GiveMeFileName(thisCellType);
if procParams.useGoodGeneSubset
    fileName = sprintf('energyGrids_goodGeneSubset%s_%s.mat',cellTypeStr,timePoints{timePointIndex});
else
    fileName = sprintf('energyGrids_%s.mat',timePoints{timePointIndex});
end
load(fileName,'energyGrids')
load('annotationGrids.mat','annotationGrids')
load('brainDivision.mat','brainDivision')

%-------------------------------------------------------------------------------
%% Create the matrix
%-------------------------------------------------------------------------------
% filters out spinal-cord voxels
isSpinalCord = ismember(annotationGrids{timePointIndex},brainDivision.SpinalCord.ID);
isAnno = annotationGrids{timePointIndex}>0;
isIncluded = getIsIncluded(procParams.thisBrainDiv,timePointNow);
voxelLabel = (isAnno & ~isSpinalCord & isIncluded); % label voxels to include
numVoxels = sum(voxellabel);
numGenes = length(energyGrids)
%-------------------------------------------------------------------------------
% Generate voxel x gene matrix
voxGeneMat = nan(numVoxels,numGenes);

h = waitbar(0,'Computing voxel x gene expression matrix...');
steps=length(energyGrids);
for j = 1:numGenes
    energyGridsNow = energyGrids{j};
    energyGridsNow = energyGridsNow(voxelLabel);
    for k = 1:numVoxels
        if energyGridsNow(k)>=0
            voxGeneMat(k,j) = energyGridsNow(k);
        end
    end
    waitbar(j/steps)
end
close(h)

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

% get all coordinates
coOrds = getCoOrds(procParams.thisBrainDiv,timePointNow);

% only keep good voxels
coOrds = coOrds(isGoodVoxel,:);

end
