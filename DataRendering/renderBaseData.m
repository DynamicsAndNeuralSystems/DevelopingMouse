function renderBaseData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData,thisBrainDiv)
  % this script creates the basic data used in the analysis.
  % It is the first matlab script to be run and should only be run once.
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
  % % Create annotation grids
  makeAnnotationGrids();
  % makes DevMouseGeneExpression.mat
  createDevMouseGeneExpression();
  % Create spinal cord ID
  makeEnrichedGenes();
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
  % Create the energy grids using all good genes, genes enriched in neurons, ...
  % oligodendrocytes and astrocytes
  makeEnergyGrid(true);
end
