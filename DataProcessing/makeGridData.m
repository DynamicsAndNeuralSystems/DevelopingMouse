function [voxGeneMat,coOrds] = makeGridData(timePointNow,procParams)
% makeGridData   Creates a voxel x gene matrix with irrelevant voxels filtered out

if nargin < 2
    procParams = GiveMeDefaultProcessingParams();
end

%-------------------------------------------------------------------------------
%% Set background variables
sizeGrids = GiveMeParameter('sizeGrids');
timePoints = GiveMeParameter('timePoints');
resolutionGrid = GiveMeParameter('resolutionGrid');
timePointIndex = find(strcmp(timePointNow,timePoints)); %match index to the chosen timepoint

%-------------------------------------------------------------------------------
%% Load matlab variables
cellTypeStr = GiveMeFileName(procParams.thisCellType);
if procParams.useGoodGeneSubset
    fileName = sprintf('energyGrids_goodGeneSubset%s_%s.mat',cellTypeStr,timePoints{timePointIndex});
else
    fileName = sprintf('energyGrids_%s.mat',timePoints{timePointIndex});
end
load(fileName,'energyGrids')
fprintf(1,'Loaded energy grid data from %s\n',fileName);
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
steps = length(energyGrids);
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
% Get all coordinates
coOrds = getCoOrds(procParams.thisBrainDiv,timePointNow);

end
