function fitHandle = makeBinningPlot_withExponential(params,timePointNow,makeNewFigure)
% Plot binned data with exponential fit
%-------------------------------------------------------------------------------

% Retrieve the time point index:
timePointIndex = find(strcmp(timePointNow,params.timePoints));

%-------------------------------------------------------------------------------
% Load the distance, CGE data:
[dist,CGE] = LoadMyDistanceCGE(params);
% Only take for the time point of interest:
dist = dist{timePointIndex};
CGE = CGE{timePointIndex};

%-------------------------------------------------------------------------------
% Bin the data:
[xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist,CGE,params.numThresholds);

%-------------------------------------------------------------------------------
% Fit the binned data (on means):
[fitHandle,stats,c] = GiveMeFit(xBinCenters,yMeans,params.whatFit,true);
% Give some info out to commandline:
fprintf('Adj R square = %d\n',stats.adjrsquare)
coeff = coeffvalues(c);
fprintf('y = %d*exp(-%d*x) + %d\n',coeff(1),coeff(3),coeff(2))

%-------------------------------------------------------------------------------
% Plot the binned data:
theColor = params.colors(timePointIndex,:);
PlotQuantiles(xThresholds,yMeans,yStds,theColor);

%-------------------------------------------------------------------------------
% Add an exponential fit:
xRange = linspace(min(dist),max(dist),100);
plot(xRange,fitHandle(xRange),'-','Color',theColor,'MarkerEdgeColor',theColor,'LineWidth',2);

%-------------------------------------------------------------------------------
% Label axes:
if params.scaledDistance
    xlabel(GiveMeLabelName('scaledDistance'));
else
    xlabel(GiveMeLabelName('originalDistance'));
end
yLabeling = GiveMeLabelName('CGE');

end
