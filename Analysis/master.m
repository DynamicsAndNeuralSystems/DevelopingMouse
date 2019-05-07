% master script that runs the entire good gene workflow
whatNorm='scaledSigmoid';
whatVoxelThreshold=0.3;
whatGeneThreshold=0.3;
numData=1000;
numThresholds=20;
incrementVector=100:100:1000;
samplingNum=100;

% these take a long time
% plot variance in decay constant against number of data points used
makeVariance(incrementVector,samplingNum);
% create annotation grids and spinal cord ID
makeAnnotationGrids_SpinalCordID();
% create the energy grids using all genes
makeEnergyGrid();
% create gene expression matrix from all genes
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,false);
% make histogram of proportion of NaN genes
makeVoxGeneMatStats_NaNGene_histogram();
% make a struct containing gene IDs from different time points
makeGeneList_gridExpression();
% make plot of gene status over time, and goodGeneSubset.mat containing IDs of ...
% genes good in all time points
makeVoxGeneMatStats_geneAcrossTime();
% create the energy grids using good genes
makeEnergyGrid_goodGeneSubset();
% create gene expression matrix from good genes
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,true);
% create distances and correlation from good genes
[~,~,~,~,~]=makeSpatialData(numData,true);
% create binned data from good genes
makeBinnedData(numData,numThresholds,true);
% perform exponential fitting on binned data from good genes
makeBinnedFitting(numData,numThresholds,true,false);
% perform exponential fitting on binned data (created from scaled distance data) from good genes
makeBinnedFitting(numData,numThresholds,true,true);
% plot the bins with fitted exponential curve
makeBinningPlot_withExponential(numData,numThresholds,true);
% plot decay constants against max distance
makeDecayConstantPlot(numData,numThresholds,true,false);
% plot decay constants of distance scaled data against max distance
makeDecayConstantPlot(numData,numThresholds,true,true);
% log-log plot of decay constant against max distance of the non-scaled data
makeDecayConstant_voxel(numData,numThresholds,true);
% plot exponential curves of all time points together
makeExponentialPlot(numData,numThresholds,true,false);
% plot exponential curves of all time points together, distance scaled
makeExponentialPlot(numData,numThresholds,true,true);
