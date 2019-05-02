% master script that runs the entire good gene workflow
whatNorm='scaledSigmoid';
whatVoxelThreshold=0.3;
whatGeneThreshold=0.3;
useGoodGeneSubset=true;
% create annotation grids and spinal cord ID
makeAnnotationGrids_SpinalCordID();
% create the energy grids using all genes
makeEnergyGrid();
% create gene expression matrix from all genes
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,useGoodGeneSubset);
% create the energy grids using good genes
