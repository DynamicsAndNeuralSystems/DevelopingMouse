function makeBinningPlot_withExponential(params,timePointNow,makeNewFigure)

% Plot bins with exponential curve fitted on top
timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints));

[xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(params);
% fitting_stat_all = getFitting(xPlotDataAll,yPlotDataAll,'decayConstant');

%-------------------------------------------------------------------------------
% Load distances and CGE scores:
[distances_all,corrCoeff_all] = LoadMyDistanceCGE(params);

%-------------------------------------------------------------------------------
if params.scaledDistance
    xLabeling = GiveMeLabelName('scaledDistance');
else
    xLabeling = GiveMeLabelName('originalDistance');
end
yLabeling = GiveMeLabelName('CGE');
colorMap = BF_getcmap('dark2',7,0,0);
for i = 1:length(timePoints)
    if makeNewFigure
        f = figure('color','w');
        box('on');
        hold('on')
    end

    % Binned data:
    PlotQuantiles_diffColor(distances_all{timePointIndex},corrCoeff_all{timePointIndex},...
                            numData,numThresholds,false,colorMap,false,...
                            timePointNow, thisBrainDiv, thisDirection);

    % Add an exponential fit:
    plotFitting_singleTimePoint(distances_all,'exp',fitting_stat_all,...
                                xLabeling, yLabeling, 1, ...
                                thisDirection, timePointNow,false, ...
                                thisBrainDiv,thisCellType);
end

%-------------------------------------------------------------------------------
% Give some info to commandline:
fprintf('Adj R square = %d\n',fitting_stat_all.(timePointNow).adjRSquare.exp)
coeff = coeffvalues(fitting_stat_all.(timePointNow).fitObject.exp);
fprintf('y = %d*exp(-%d*x) + %d\n',coeff(1),coeff(3),coeff(2))

end
