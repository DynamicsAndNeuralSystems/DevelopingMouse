function renderBaseData(procParams)
% this script creates the basic data used in the analysis.
% It is the first matlab script to be run and should only be run once.
% renders raw data into mat variables which are saved in Matlab_variables (these take a long time)

%-------------------------------------------------------------------------------
% Check inputs:
%-------------------------------------------------------------------------------
if nargin < 1
    procParams = GiveMeDefaultProcessingParams();
end

%-------------------------------------------------------------------------------
% % Create annotation grids
makeAnnotationGrids();

% makes DevMouseGeneExpression.mat
createDevMouseGeneExpression();

% create matlab variable with IDs of brain subdivisions (forebrain, midbrain, hindbrain, Dpallidum, SpinalCord)
makeBrainDivision();

% Create the energy grids using all genes
makeEnergyGrid(false);

% Create gene-expression matrix from all genes (gets the good genes)
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
                      'wholeBrain','allCellTypes',false);

% create geneID_gridExpression.mat
makeGeneList_gridExpression();

% create goodGeneSubset.mat
makeVoxGeneMatStats_geneAcrossTime();

% Create enrichedGenes.mat
makeEnrichedGenes();

% Create the energy grids using all good genes, genes enriched in neurons, ...
% oligodendrocytes and astrocytes
makeEnergyGrid(true);

end
