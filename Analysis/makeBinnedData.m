function [xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(numData,...
                                                                    numThresholds,...
                                                                    thisBrainDiv,...
                                                                    scaledDistance,...
                                                                    thisCellType,...
                                                                    thisDirection)
% Bins the coexpression-distance data into numThresholds-1 bins
if scaledDistance
    distanceStr = GiveMeFileName('scaled');
else
    distanceStr = GiveMeFileName('notScaled');
end
cellTypeStr = GiveMeFileName(thisCellType);
brainStr = GiveMeFileName(thisBrainDiv);
% load the spatial data
if strcmp(thisDirection,'allDirections')
  fileString = sprintf('spatialData_NumData_%d%s%s%s.mat',numData,brainStr,cellTypeStr,...
                        distanceStr);
else
  fileString = sprintf('directionalityData_%s%s.mat',thisDirection,distanceStr);
end
load(fileString,'distances_all','corrCoeff_all');

timePoints = GiveMeParameter('timePoints');

% Bin the data
[xPlotDataAll,yPlotDataAll,~] = plotBinning(distances_all,corrCoeff_all,...
                                                numThresholds);
end
