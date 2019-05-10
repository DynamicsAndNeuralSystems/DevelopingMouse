% master script that runs the entire good gene workflow
whatNorm='scaledSigmoid';
whatVoxelThreshold=0.3;
whatGeneThreshold=0.3;
numData=1000;
numThresholds=21;
incrementVector=100:100:1000;
samplingNum=100;
timePoints = GiveMeParameter('timePoints');
smallBrainDivisions = GiveMeParameter('smallBrainDivisions');
brainDivisions = GiveMeParameter('brainDivisions');
directions = GiveMeParameter('directions');
cellTypes = GiveMeParameter('cellTypes');
smallCellTypes = GiveMeParameter('smallCellTypes');
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
% cell types, using good gene subset, with or without directions
% temporary (done on Massive, for makeFigure2)
makeSpatialData(1000,'wholeBrain',false,'allCellTypes',true); % unscaled distance global data (in mm)
makeSpatialData(1000,'wholeBrain',true,'allCellTypes',true); % scaled distance global data (in mm)
% testing on massive
createSpatialData(numData,true);

% makes cgeMat and distMat for figure 1
createSpatialMat('E11pt5','allCellTypes','wholeBrain',numData);

% make distances and correlation coefficient of 3 directions
for j=1:length(directions)
  makeDirectionalityData(numData,false,directions{j});
end
% create the data of variance in decay constant against number of data points used
makeVariance(incrementVector,samplingNum);
% ------------------------------------------------------------------------------

% plot variance in decay constant against number of data points used
plotVariance();

% make histogram of proportion of NaN genes
makeVoxGeneMatStats_NaNGene_histogram();

% make plot of gene status over time, and goodGeneSubset.mat containing IDs of ...
% genes good in all time points
makeVoxGeneMatStats_geneAcrossTime();

% plot the bins with fitted exponential curve (distance unscaled)

for i=1:length(timePoints)
  makeBinningPlot_withExponential(numData,numThresholds,'wholeBrain',...
                                  false,'wholeBrain','allDirections',...
                                  timePoints{i},true);
end
% plot decay constants, free parameter and multiplier against max distance
makeFigure3();
% plot decay constants against max distance (distance scaled)
makeConstantPlot(numData,numThresholds,'wholeBrain',true,'allCellTypes',...
                'allDirections',true,'decayConstant');
% plot exponential curves of all time points together, whole brian
makeExponentialPlot(numData,numThresholds,...
                    'wholeBrain',false,...
                    'allDirections','allCellTypes',true);
% plot exponential curves of all time points together, distance scaled
makeExponentialPlot(numData,numThresholds,...
                    'wholeBrain',true,...
                    'allDirections','allCellTypes',true);

% create binning plot with exponential curve for brain subdivisions
for j=1:length(smallBrainDivisions)
  for i=1:length(timePoints)
    makeBinningPlot_withExponential(numData,numThresholds,...
                                    smallBrainDivisions{j},false,...
                                    'allCellTypes','allDirections',...
                                    timePoints{i},true)
  end
end
% plot exponential curves of different time points together for brain subdivisions
for j=1:length(smallBrainDivisions)
  makeExponentialPlot(numData,numThresholds,...
                      smallBrainDivisions{j},false,...
                      'allDirections','allCellTypes',true);
end
% create binning plot with exponential curve for brain subdivisions (scaled distance)
for j=1:length(smallBrainDivisions)
  for i=1:length(timePoints)
    makeBinningPlot_withExponential(numData,numThresholds,...
                                    smallBrainDivisions{j},true,...
                                    'allCellTypes','allDirections',...
                                    timePoints{i},true)
  end
end
% plot exponential curves of different time points together for brain subdivisions...
% (scaled distance)
for j=1:length(smallBrainDivisions)
  makeExponentialPlot(numData,numThresholds,...
                      smallBrainDivisions{j},true,...
                      'allDirections','allCellTypes',true);
end

% plot decay constant against max distance (distance scaled)
for j=1:length(smallBrainDivisions)
  makeConstantPlot(numData,numThresholds,smallBrainDivisions{j},...
                  true,'allCellTypes','allDirections',...
                  true,'decayConstant')
end

%% analysis of directions
% plot the bins of different directions with exponential
for j=1:length(directions)
  for i=1:length(timePoints)
    makeBinningPlot_withExponential(numData,numThresholds,...
                                    'wholeBrain',false,...
                                    'allCellTypes',directions{j},...
                                    timePoints{i},true)
  end
end
% plot exponential curves of different directions of different time points together
for j=1:length(directions)
  makeExponentialPlot(numData,numThresholds,...
                      'wholeBrain',false,...
                      directions{j},'allCellTypes',true);
end

% plot decay constant of different directions against max distance
for j=1:length(directions)
  makeConstantPlot(numData,numThresholds,'wholeBrain',...
                          false,'allCellTypes',directions{j},...
                          true,'decayConstant');
end
% plot exponential curves of different directions of different time points together
% (distance scaled)
for j=1:length(directions)
  makeExponentialPlot(numData,numThresholds,...
                      'wholeBrain',true,...
                      directions{j},'allCellTypes',true);
end
% plot decay constant of different directions against max distance (distance scaled)
f=figure('color','w');
for j=1:length(directions)
  makeConstantPlot(numData,numThresholds,'wholeBrain',...
                          false,'allCellTypes',directions{j},...
                          false,'decayConstant');
  hold on
end

% plot the bins of enriched genes with exponential in wholeBrain,forebrain,...
% midbrain and hindbrain
for j=1:length(cellTypes)
  for i=1:length(timePoints)
    makeBinningPlot_withExponential(numData,numThresholds,...
                                    'wholeBrain',false,...
                                    cellTypes{k},'allDirections',...
                                    timePoints{i},true);
  end
end
% plot exponential curves of enriched genes of different time points together
for j=1:length(cellTypes)
  for k=1:length(brainDivisions)
    makeExponentialPlot(numData,numThresholds,...
                        brainDivisions{k},false,...
                        'allDirections',cellTypes{j},true);
  end
end
% plot decay constant of different directions against max distance
for j=1:length(brainDivisions)
  f=figure('color','w');
  for k=1:length(cellTypes)
    makeConstantPlot(numData,numThresholds,brainDivisions{j},...
                    false,cellTypes{k},'allDirections',...
                    false,'decayConstant');
  end
end
% plot exponential curves of enriched genes of different time points together
% (distance scaled)
for j=1:length(cellTypes)
  for k=1:length(brainDivisions)
    makeExponentialPlot(numData,numThresholds,...
                        brainDivisions{k},true,...
                        'allDirections',cellTypes{j},true);
  end
end
