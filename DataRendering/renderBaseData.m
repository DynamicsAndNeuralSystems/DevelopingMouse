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
% Create annotation grids
% -> annotationGrids.mat
makeAnnotationGrids();

% makes DevMouseGeneExpression.mat
% createDevMouseGeneExpression();

% create matlab variable with IDs of brain subdivisions (forebrain, midbrain, hindbrain, Dpallidum, SpinalCord)
% -> brainDivision.mat
makeBrainDivision();

% Create the energy grids across all time points
% -> energyGrids_*.mat
makeEnergyGrid(procParams);

% Create gene-expression matrix across all time points:
% voxelGeneExpression%s%s_%s.mat
makeGeneExpressionMatrix(procParams);

% Assemble gene IDs at each time point:
% -> geneID_gridExpression.mat
makeGeneList_gridExpression();

% create goodGeneSubset.mat
makeVoxGeneMatStats_geneAcrossTime();

% Create enrichedGenes.mat
makeEnrichedGenes();

% Create the energy grids using all good genes, genes enriched in neurons, ...
% oligodendrocytes and astrocytes
% makeEnergyGrid(true);

end
