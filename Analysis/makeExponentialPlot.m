function makeExponentialPlot(numData,numThresholds,...
                            thisBrainDiv,scaledDistance,...
                            thisDirection,thisCellType,makeNewFigure)
% plots all exponential curves from different time points on the same graph
timePoints=GiveMeParameter('timePoints');
[xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(numData,...
                                                            numThresholds,...
                                                            thisBrainDiv,...
                                                            scaledDistance,...
                                                            thisCellType,...
                                                            thisDirection);

[fitting_stat_all,decayConstant,maxDistance] = makeBinnedFitting(xPlotDataAll,...
                                                                  yPlotDataAll,...
                                                                  numThresholds);
% set file name parameters
brainStr = GiveMeFileName(thisBrainDiv);
cellTypeStr = GiveMeFileName(thisCellType);
if scaledDistance
  distanceStr = GiveMeFileName('scaled');
else
  distanceStr = GiveMeFileName('notScaled');
end

if strcmp(thisDirection,'allDirections')
  fileString = sprintf('spatialData_NumData_%d%s%s%s.mat',numData,brainStr,cellTypeStr,...
                    distanceStr);
else
  fileString = sprintf('directionalityData_%s%s.mat',thisDirection,distanceStr);
end

load(fileString,'distances_all','corrCoeff_all');

cmapOut = BF_getcmap('dark2',7,0,0);
if scaledDistance
  xLabeling=GiveMeLabelName('scaledDistance');
else
  xLabeling=GiveMeLabelName('originalDistance');
end
if makeNewFigure
  f = figure('color','w','Position',get(0,'Screensize'));
end
for i=1:length(timePoints)
  plotFitting_singleTimePoint(distances_all,'exp',fitting_stat_all,...
                              xLabeling, 1, ...
                              thisDirection, timePoints{i},false, ...
                              thisBrainDiv,thisCellType,false);
  hold on
end
end
