function PlotQuantiles(xThresholds,yBinMeans,yBinStds,theColor)
% Plots x-y scatter, but with mean of y plotted in quantiles of x
%-------------------------------------------------------------------------------

numThresholds = length(xThresholds);
theStyle = '-';
theLineWidth = 1;

% ------------------------------------------------------------------------------
% Plot the bin extents with bin centers as circles:
hold('on')
for k = 1:numThresholds-1
    plot(xThresholds(k:k+1),ones(2,1)*yBinMeans(k),'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
    plot(xThresholds(k:k+1),ones(2,1)*(yBinMeans(k)+yBinStds(k)),'LineStyle','--',...
        'LineWidth',theLineWidth,'Color',theColor)
    plot(xThresholds(k:k+1),ones(2,1)*(yBinMeans(k)-yBinStds(k)),'LineStyle','--',...
        'LineWidth',theLineWidth,'Color',theColor)
    plot(mean(xThresholds(k:k+1)),yBinMeans(k),'o','MarkerSize',5,'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
end
xlim([0 xThresholds(end)])

end
