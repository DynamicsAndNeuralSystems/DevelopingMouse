function makeExponentialPlot(params)
% Plots all exponential curves from different time points on the same graph
%-------------------------------------------------------------------------------

% Load the distance, CGE data:
[dist,CGE] = LoadMyDistanceCGE(params);

%-------------------------------------------------------------------------------
numTimePoints = length(params.timePoints);
hold('on');
for i = 1:numTimePoints
    % Bin the data:
    [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist{i},CGE{i},params.numThresholds);

    % Fit the binned data (on means):
    [fitHandle,stats,c] = GiveMeFit(xBinCenters,yMeans,params.whatFit,true);

    % Plot it:
    xRange = linspace(min(dist{i}),max(dist{i}),100);
    plot(xRange,fitHandle(xRange),'-','Color',params.colors(i,:),'MarkerEdgeColor',params.colors(i,:),'LineWidth',2);
end

%-------------------------------------------------------------------------------
% Label axis:
if params.scaledDistance
    xlabel(GiveMeLabelName('scaledDistance'));
else
    xlabel(GiveMeLabelName('originalDistance'));
end
ylabel('Correlated gene expression')


end
