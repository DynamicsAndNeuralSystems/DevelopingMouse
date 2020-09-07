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
fileName = sprintf('energyGrids_%s.mat',timePointNow);
fprintf(1,'Loading energy grid data from ''%s''...\n',fileName);
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
fprintf(1,'%u spinal cord voxels\n',sum(isSpinalCord(:)));
isAnnotated = myAnnotationGrid>0;
fprintf(1,'%u annotated voxels\n',sum(isAnnotated(:)));
% isIncluded = getIsIncluded(procParams.thisBrainDiv,timePointNow);
voxelInclude = (isAnnotated & ~isSpinalCord); % label voxels to include
fprintf(1,'%u annotated, non-spinal cord voxels\n',sum(voxelInclude(:)));
numVoxels = sum(voxelInclude(:));
numGenes = length(energyGrids);

%-------------------------------------------------------------------------------
% Generate voxel x gene matrix
voxGeneMat = nan(numVoxels,numGenes);

h = waitbar(0,sprintf('Computing %u voxel x %u gene expression matrix...',numVoxels,numGenes));
steps = length(energyGrids);
for j = 1:numGenes
    energyGridsNow = energyGrids{j};
    energyGridsNow = energyGridsNow(voxelInclude);
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
[a,b,c] = ind2sub(sizeGrids.(timePoints{timePointIndex}),find(voxelInclude));
coOrds = horzcat(a,b,c);

%-------------------------------------------------------------------------------
% Label voxels by brain area:
voxStructIDs = myAnnotationGrid(voxelInclude);
isForebrain = ismember(voxStructIDs,brainDivision.forebrain.ID);
isMidbrain = ismember(voxStructIDs,brainDivision.midbrain.ID);
isHindbrain = ismember(voxStructIDs,brainDivision.hindbrain.ID);
isDpall = ismember(voxStructIDs,brainDivision.Dpallidum.ID);
if strcmp(timePointNow,'P56') & procParams.adultCoronal
    isLeft = coOrds(:,3) < max(coOrds(:,3))/2;
    voxLabelTable = table(voxStructIDs,isForebrain,isMidbrain,isHindbrain,isDpall,isLeft);
else
    voxLabelTable = table(voxStructIDs,isForebrain,isMidbrain,isHindbrain,isDpall);
end

%-------------------------------------------------------------------------------
% Save to .mat file:
fileName = fullfile('Matlab_variables',sprintf('voxelGeneExpression_%s.mat',timePointNow));
save(fileName,'voxGeneMat','coOrds','voxLabelTable','geneIDs','-v7.3');
fprintf(1,'Saved processed gene-expression data to ''%s''\n',fileName);

end
