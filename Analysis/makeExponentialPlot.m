function makeExponentialPlot(params,makeNewFigure)
% Plots all exponential curves from different time points on the same graph

% Do basic fitting:
[xPlotDataAll,yPlotDataAll] = makeBinnedData(params);
fitting_stat_all = getFitting(xPlotDataAll,yPlotDataAll,'decayConstant');

%-------------------------------------------------------------------------------
% Load distance, CGE data:
[distances_all,corrCoeff_all] = LoadMyDistanceCGE(params);

%-------------------------------------------------------------------------------
% Plotting:
if makeNewFigure
    f = figure('color','w');
end
hold('on');
if scaledDistance
    xLabeling = GiveMeLabelName('scaledDistance');
else
    xLabeling = GiveMeLabelName('originalDistance');
end

%-------------------------------------------------------------------------------
numTimePoints = length(params.timePoints);
for i = 1:numTimePoints
    % The function handle for the fit of interest:
    fit_funHandle = fitting_stat_all.(params.timePoints{i}).fHandle.(params.fitType);

    % Plot it:
    plotFitting_singleTimePoint(xPlotDataAll{i},params,fit_funHandle,xDataDensity,params.colors(i,:),false)

    % Label axes:
    xlabel(xLabeling)
    ylabel(GiveMeLabelName('CGE'))
end

end
