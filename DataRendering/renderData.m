function renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData)
% renders raw data into mat variables which are saved in Matlab_variables (these take a long time)
brainDivisions=GiveMeParameter('brainDivisions');
cellTypes=GiveMeParameter('cellTypes');
% Create annotation grids and spinal cord ID
makeAnnotationGrids_SpinalCordID();
% make a matlab variable containing enriched genes
makeEnrichedGenes();

% Create the energy grids using all genes
makeEnergyGrid(false);

% Create gene-expression matrix from all genes (gets the good genes)
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
                        'wholeBrain','allCellTypes',false)
% make a struct containing gene IDs from different time points
makeGeneList_gridExpression();

% Create the energy grids using all good genes, genes enriched in neurons, ...
% oligodendrocytes and astrocytes
makeEnergyGrid(true);
% create matlab variable with IDs of brain subdivisions
makeBrainDivision();
% repeat running this function to create gene expression matrix from
% good genes (wholeBrain,forebrain,midbrain and hindbrain), and from different cell types
for j=1:length(brainDivisions)
  for k=1:length(cellTypes)
  makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
                          brainDivisions{j},cellTypes{k},true);
  end
end
% create distances, correlation and directions for different brain divisions, ...
% cell types, using good gene subset
createSpatialData(numData,false);
% makes cgeMat and distMat for figure 1
createSpatialMat('E11pt5','allCellTypes','wholeBrain',numData);
end
