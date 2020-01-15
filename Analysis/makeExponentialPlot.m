function makeExponentialPlot(params,makeNewFigure)
% Plots all exponential curves from different time points on the same graph

[xPlotDataAll,yPlotDataAll] = makeBinnedData(params);

fitting_stat_all = getFitting(xPlotDataAll,yPlotDataAll,'decayConstant');

%-------------------------------------------------------------------------------
% Load distance, CGE data:
[distances_all,corrCoeff_all] = LoadMyDistanceCGE(params);

%-------------------------------------------------------------------------------
% Plotting:
if scaledDistance
    xLabeling = GiveMeLabelName('scaledDistance');
else
    xLabeling = GiveMeLabelName('originalDistance');
end
yLabeling = GiveMeLabelName('CGE');

%-------------------------------------------------------------------------------
if makeNewFigure
    f = figure('color','w');
end
hold('on');

%-------------------------------------------------------------------------------
timePoints = GiveMeParameter('timePoints');
numTimePoints = length(timePoints);
for i = 1:numTimePoints
    plotFitting_singleTimePoint(distances_all,'exp',fitting_stat_all,...
                              xLabeling, yLabeling, 1, ...
                              thisDirection,timePoints{i},false, ...
                              thisBrainDiv,thisCellType);
end

end
