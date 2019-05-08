% master script that runs the entire good gene workflow
whatNorm='scaledSigmoid';
whatVoxelThreshold=0.3;
whatGeneThreshold=0.3;
numData=1000;
numThresholds=20;
incrementVector=100:100:1000;
samplingNum=100;

% ------------------------------------------------------------------------------
% Process raw data from Allen API
% ------------------------------------------------------------------------------
% Save into .mat file in Matlab_variables (these take a long time)

% Create annotation grids and spinal cord ID
makeAnnotationGrids_SpinalCordID();
% make a matlab variable containing enriched genes
makeEnrichedGenes();

% Create the energy grids using all genes
makeEnergyGrid(false);

% Create gene-expression matrix from all genes (gets the good genes)
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,'wholeBrain');

% make a struct containing gene IDs from different time points
makeGeneList_gridExpression();

% Create the energy grids using all good genes, genes enriched in neurons, ...
% oligodendrocytes and astrocytes
makeEnergyGrid(true);

% repeat running this function to create gene expression matrix from good genes
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,'wholeBrain');

% create matlab variable with IDs of brain subdivisions
makeBrainDivision();

% create distances, correlation and directions for different brain divisions, ...
% cell types, using good gene subset, with or without directions
% temporary:
makeSpatialData(1000,'wholeBrain',false,'allCellTypes',true); % unscaled distance global data (in mm)
makeSpatialData(1000,'wholeBrain',true,'allCellTypes',true); % scaled distance global data (in mm)
% for later (not tested yet):
createSpatialData(numData,true);
% ------------------------------------------------------------------------------

% plot variance in decay constant against number of data points used
makeVariance(incrementVector,samplingNum);

% make histogram of proportion of NaN genes
makeVoxGeneMatStats_NaNGene_histogram();

% make plot of gene status over time, and goodGeneSubset.mat containing IDs of ...
% genes good in all time points
makeVoxGeneMatStats_geneAcrossTime();

% plot the bins with fitted exponential curve (distance unscaled)
makeBinningPlot_withExponential(numData,numThresholds,true,'wholeBrain',false);
% plot the bins with fitted exponential curve (distance scaled)
makeBinningPlot_withExponential(numData,numThresholds,true,'wholeBrain',true);
% plot decay constants against max distance
makeDecayConstantPlot(numData,numThresholds,true,'wholeBrain',false);
% plot decay constants against max distance (distance scaled)
makeDecayConstantPlot(numData,numThresholds,true,'wholeBrain',true);
% log-log plot of decay constant against max distance of the non-scaled data
makeDecayConstant_voxel(numData,numThresholds,true);
% Linear plot of decay constant against max distance of the scaled data
makeDecayConstant_linear_voxel(numData,numThresholds,true);
% plots the free parameter and multiplier
makeStatsPlot(numData,numThresholds,true,'wholeBrain');
% plot exponential curves of all time points together
makeExponentialPlot(numData,numThresholds,true,'wholeBrain',false);
% plot exponential curves of all time points together, distance scaled
makeExponentialPlot(numData,numThresholds,true,'wholeBrain',true);


% make gene expression matrix of brain subdivisions
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,true,'forebrain'); % use good gene subset only
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,true,'midbrain');
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,true,'hindbrain');

% bin the data of brain subdivisions
makeBinnedData(numData,numThresholds,true,'forebrain',false);
makeBinnedData(numData,numThresholds,true,'midbrain',false);
makeBinnedData(numData,numThresholds,true,'hindbrain',false);
% create fitting for brain subdivisions
makeBinnedFitting(numData,numThresholds,true,'forebrain',false);
makeBinnedFitting(numData,numThresholds,true,'midbrain',false);
makeBinnedFitting(numData,numThresholds,true,'hindbrain',false);
% create binning plot with exponential curve for brain subdivisions
makeBinningPlot_withExponential(numData,numThresholds,true,'forebrain',false,false);
makeBinningPlot_withExponential(numData,numThresholds,true,'midbrain',false,false);
makeBinningPlot_withExponential(numData,numThresholds,true,'hindbrain',false,false);
% plot exponential curves of different time points together for brain subdivisions
makeExponentialPlot(numData,numThresholds,true,'forebrain',false);
makeExponentialPlot(numData,numThresholds,true,'midbrain',false);
makeExponentialPlot(numData,numThresholds,true,'hindbrain',false);
% bin the data of brain subdivisions (scaled distance)
makeBinnedData(numData,numThresholds,true,'forebrain',true);
makeBinnedData(numData,numThresholds,true,'midbrain',true);
makeBinnedData(numData,numThresholds,true,'hindbrain',true);
% create fitting for brain subdivisions (scaled distance)
makeBinnedFitting(numData,numThresholds,true,'forebrain',true);
makeBinnedFitting(numData,numThresholds,true,'midbrain',true);
makeBinnedFitting(numData,numThresholds,true,'hindbrain',true);
% create binning plot with exponential curve for brain subdivisions (scaled distance)
makeBinningPlot_withExponential(numData,numThresholds,true,'forebrain',true);
makeBinningPlot_withExponential(numData,numThresholds,true,'midbrain',true);
makeBinningPlot_withExponential(numData,numThresholds,true,'hindbrain',true);

% plot exponential curves of different time points together for brain subdivisions...
% (scaled distance)
makeExponentialPlot(numData,numThresholds,true,'forebrain',true);
makeExponentialPlot(numData,numThresholds,true,'midbrain',true);
makeExponentialPlot(numData,numThresholds,true,'hindbrain',true);
% plot decay constant against max distance (distance scaled)
makeDecayConstantPlot(numData,numThresholds,true,'forebrain',false);
makeDecayConstantPlot(numData,numThresholds,true,'midbrain',false);
makeDecayConstantPlot(numData,numThresholds,true,'hindbrain',false);

%% analysis of directions
% make distances and correlation coefficient of 3 directions
makeDirectionalityData(numData,false);
% bin the data of different directions
makeBinnedData_direction(numData,numThresholds,false,'sagittal');
makeBinnedData_direction(numData,numThresholds,false,'coronal');
makeBinnedData_direction(numData,numThresholds,false,'axial');
% fit the binned data of different directions with exponential
makeBinnedFitting_direction(numData,numThresholds,false,'sagittal');
makeBinnedFitting_direction(numData,numThresholds,false,'coronal');
makeBinnedFitting_direction(numData,numThresholds,false,'axial');
% plot the bins of different directions with exponential
makeBinningPlot_withExponential_direction(numData,numThresholds,false,'sagittal');
makeBinningPlot_withExponential_direction(numData,numThresholds,false,'coronal');
makeBinningPlot_withExponential_direction(numData,numThresholds,false,'axial');
% plot exponential curves of different directions of different time points together
makeExponentialPlot_direction(numData,numThresholds,false,'sagittal','wholeBrain');
makeExponentialPlot_direction(numData,numThresholds,false,'coronal','wholeBrain');
makeExponentialPlot_direction(numData,numThresholds,false,'axial','wholeBrain');
% plot decay constant of different directions against max distance
makeDecayConstantPlot_direction(numData,numThresholds,false);
% make distances and correlation coefficient of 3 directions (distance scaled)
makeDirectionalityData(numData,true);
% bin the data of different directions (distance scaled)
makeBinnedData_direction(numData,numThresholds,true,'sagittal');
makeBinnedData_direction(numData,numThresholds,true,'coronal');
makeBinnedData_direction(numData,numThresholds,true,'axial');
% fit the binned data of different directions with exponential (distance scaled)
makeBinnedFitting_direction(numData,numThresholds,true,'sagittal');
makeBinnedFitting_direction(numData,numThresholds,true,'coronal');
makeBinnedFitting_direction(numData,numThresholds,true,'axial');
% plot the bins of different directions with exponential (distance scaled)
makeBinningPlot_withExponential_direction(numData,numThresholds,true,'sagittal');
makeBinningPlot_withExponential_direction(numData,numThresholds,true,'coronal');
makeBinningPlot_withExponential_direction(numData,numThresholds,true,'axial');
% plot exponential curves of different directions of different time points together
% (distance scaled)
makeExponentialPlot_direction(numData,numThresholds,true,'sagittal','wholeBrain');
makeExponentialPlot_direction(numData,numThresholds,true,'coronal','wholeBrain');
makeExponentialPlot_direction(numData,numThresholds,true,'axial','wholeBrain');
% plot decay constant of different directions against max distance (distance scaled)
makeDecayConstantPlot_direction(numData,numThresholds,true);


% make energy grids using enriched genes only
makeEnergyGrid_enrichedGenes('neuron');
makeEnergyGrid_enrichedGenes('oligodendrocyte');
makeEnergyGrid_enrichedGenes('astrocyte');
% make gene expression matrix of using enriched genes
makeGeneExpressionMatrix_enrichedGenes(whatNorm,whatVoxelThreshold,whatGeneThreshold,'wholeBrain','neuron'); % use all genes
makeGeneExpressionMatrix_enrichedGenes(whatNorm,whatVoxelThreshold,whatGeneThreshold,'wholeBrain','oligodendrocyte');
makeGeneExpressionMatrix_enrichedGenes(whatNorm,whatVoxelThreshold,whatGeneThreshold,'wholeBrain','astrocyte');
% bin the data of enriched genes
makeBinnedData_enrichedGenes(numData,numThresholds,'wholeBrain','neuron',false);
makeBinnedData_enrichedGenes(numData,numThresholds,'wholeBrain','oligodendrocyte',false);
makeBinnedData_enrichedGenes(numData,numThresholds,'wholeBrain','astrocyte',false);
% fit the data of enriched genes to exponential
makeBinnedFitting_enrichedGenes(numData,numThresholds,'wholeBrain','neuron',false);
makeBinnedFitting_enrichedGenes(numData,numThresholds,'wholeBrain','oligodendrocyte',false);
makeBinnedFitting_enrichedGenes(numData,numThresholds,'wholeBrain','astrocyte',false);
% plot the bins of enriched genes with exponential
makeBinningPlot_withExponential_enrichedGenes(numData,numThresholds,'wholeBrain',...
                                              'neuron',false);
makeBinningPlot_withExponential_enrichedGenes(numData,numThresholds,'wholeBrain',...
                                              'oligodendrocyte',false);
makeBinningPlot_withExponential_enrichedGenes(numData,numThresholds,'wholeBrain',...
                                              'astrocyte',false);
% plot exponential curves of enriched genes of different time points together
makeExponentialPlot_enrichedGenes(numData,numThresholds,false,'neuron');
makeExponentialPlot_enrichedGenes(numData,numThresholds,false,'oligodendrocyte');
makeExponentialPlot_enrichedGenes(numData,numThresholds,false,'astrocyte');
% plot decay constant of different directions against max distance
makeDecayConstantPlot_enrichedGenes(numData,numThresholds,false);
% bin the data of enriched genes (distance scaled)
makeBinnedData_enrichedGenes(numData,numThresholds,'wholeBrain','neuron',true);
makeBinnedData_enrichedGenes(numData,numThresholds,'wholeBrain','oligodendrocyte',true);
makeBinnedData_enrichedGenes(numData,numThresholds,'wholeBrain','astrocyte',true);
% fit the data of enriched genes to exponential (distance scaled)
makeBinnedFitting_enrichedGenes(numData,numThresholds,'wholeBrain','neuron',true);
makeBinnedFitting_enrichedGenes(numData,numThresholds,'wholeBrain','oligodendrocyte',true);
makeBinnedFitting_enrichedGenes(numData,numThresholds,'wholeBrain','astrocyte',true);
% plot the bins of enriched genes with exponential (distance scaled)
makeBinningPlot_withExponential_enrichedGenes(numData,numThresholds,'wholeBrain',...
                                              'neuron',true);
makeBinningPlot_withExponential_enrichedGenes(numData,numThresholds,'wholeBrain',...
                                              'oligodendrocyte',true);
makeBinningPlot_withExponential_enrichedGenes(numData,numThresholds,'wholeBrain',...
                                              'astrocyte',true);
% plot exponential curves of enriched genes of different time points together
% (distance scaled)
makeExponentialPlot_enrichedGenes(numData,numThresholds,true,'neuron');
makeExponentialPlot_enrichedGenes(numData,numThresholds,true,'oligodendrocyte');
makeExponentialPlot_enrichedGenes(numData,numThresholds,true,'astrocyte');
