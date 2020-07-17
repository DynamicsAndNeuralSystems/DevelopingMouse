function [voxGeneMat,coOrds] = makeGridData(timePointNow,procParams)
% makeGridData   Creates a voxel x gene matrix with irrelevant voxels filtered out

if nargin < 2
    procParams = GiveMeDefaultParams();
end

%-------------------------------------------------------------------------------
%% Set background variables
timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints)); %match index to the chosen timepoint

%-------------------------------------------------------------------------------
%% Load matlab variables
% Gene data and information:
fprintf(1,'Loading energy grid data from ''%s''...\n',fileName);
fileName = sprintf('energyGrids_%s.mat',timePointNow);
load(fileName,'energyGrids','geneIDInfo')
% Label columns as gene IDs:
geneIDs = geneIDInfo;
% try
%     load(fileName,'geneIDs')
% catch
%     geneIDs = GetGeneIDs(timePointNow);
% end

% Annotation IDs for voxels:
load('annotationGrids.mat','annotationGrids')
myAnnotationGrid = annotationGrids{timePointIndex};
load('brainDivision.mat','brainDivision')

%-------------------------------------------------------------------------------
%% Create the matrix
%-------------------------------------------------------------------------------
% Filter out spinal-cord voxels
isSpinalCord = ismember(myAnnotationGrid,brainDivision.SpinalCord.ID);
isAnnotated = myAnnotationGrid>0;
% isIncluded = getIsIncluded(procParams.thisBrainDiv,timePointNow);
voxelIncude = (isAnnotated & ~isSpinalCord); % label voxels to include
numVoxels = sum(voxelIncude(:));
numGenes = length(energyGrids);
keyboard

%-------------------------------------------------------------------------------
% Generate voxel x gene matrix
voxGeneMat = nan(numVoxels,numGenes);

h = waitbar(0,sprintf('Computing %u voxel x %u gene expression matrix...',numVoxels,numGenes));
steps = length(energyGrids);
for j = 1:numGenes
    energyGridsNow = energyGrids{j};
    energyGridsNow = energyGridsNow(voxelIncude);
    for k = 1:numVoxels
        if energyGridsNow(k)>=0
            voxGeneMat(k,j) = energyGridsNow(k);
        end
    end
    waitbar(j/steps)
end
close(h)

%-------------------------------------------------------------------------------
% Get all coordinates:
% (replaces getCoOrds)
sizeGrids = GiveMeParameter('sizeGrids');
[a,b,c] = ind2sub(sizeGrids.(timePoints{timePointIndex}),find(voxelIncude));
coOrds = horzcat(a,b,c);

%-------------------------------------------------------------------------------
% Label voxels by brain area:
voxStructIDs = myAnnotationGrid(voxelIncude);
isForebrain = ismember(voxStructIDs,brainDivision.forebrain.ID);
isMidbrain = ismember(voxStructIDs,brainDivision.midbrain.ID);
isHindbrain = ismember(voxStructIDs,brainDivision.hindbrain.ID);
isDpall = ismember(voxStructIDs,brainDivision.Dpallidum.ID);
voxLabelTable = table(voxStructIDs,isForebrain,isMidbrain,isHindbrain,isDpall);

%-------------------------------------------------------------------------------
% Save to .mat file:
fileName = fullfile('Matlab_variables',sprintf('voxelGeneExpression_%s.mat',timePointNow));
save(fileName,'voxGeneMat','coOrds','voxLabelTable','geneIDs','-v7.3');
fprintf(1,'Saved processed gene-expression data to ''%s''\n',fileName);

end
