function renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData,thisBrainDiv)
% renders raw data into mat variables which are saved in Matlab_variables (these take a long time)
if nargin < 5
  thisBrainDiv='wholeBrain';
if nargin < 4
  numData=GiveMeParameter('numData');
end
if nargin < 3
  whatGeneThreshold=GiveMeParameter('whatGeneThreshold');
end
if nargin < 2
  whatVoxelThreshold=GiveMeParameter('whatVoxelThreshold');
end
if nargin < 1
  whatNorm=GiveMeParameter('whatNorm');
end

brainDivisions=GiveMeParameter('brainDivisions');
cellTypes=GiveMeParameter('cellTypes');
% % Create annotation grids
% makeAnnotationGrids();
% % Create spinal cord ID
% makeEnrichedGenes();
% % create matlab variable with IDs of brain subdivisions (forebrain, midbrain, hindbrain, Dpallidum, SpinalCord)
% makeBrainDivision();
% % Create the energy grids using all genes
% makeEnergyGrid(false);
%
% % Create gene-expression matrix from all genes (gets the good genes)
% makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
%                         'wholeBrain','allCellTypes',false);
%
% % Create the energy grids using all good genes, genes enriched in neurons, ...
% % oligodendrocytes and astrocytes
% makeEnergyGrid(true);

% repeat running this function to create gene expression matrix from
% good genes (wholeBrain,forebrain,midbrain and hindbrain), and from different cell types
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
                        thisBrainDiv,'allCellTypes',false);
% create distances, correlation and directions for different brain divisions, ...
% cell types, using good gene subset
createSpatialData(numData,false);
% makes cgeMat and distMat for figure 1
createSpatialMat('E11pt5','allCellTypes','wholeBrain',numData);
end
