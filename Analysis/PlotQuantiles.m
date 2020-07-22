function ph = PlotQuantiles(xThresholds,yBinMeans,yBinStds,theColor,doSimple)
% Plots x-y scatter, but with mean of y plotted in quantiles of x
%-------------------------------------------------------------------------------

if nargin < 5
    doSimple = false;
end

numThresholds = length(xThresholds);
theStyle = '-';
theLineWidth = 1;

% ------------------------------------------------------------------------------
% Plot the bin extents with bin centers as circles:
hold('on')
if doSimple
    thresholdMiddles = mean([xThresholds(1:end-1);xThresholds(2:end)],1);
    ph = plot(thresholdMiddles,yBinMeans,'o-','MarkerSize',5,'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor);
else
    for k = 1:numThresholds-1
        plot(xThresholds(k:k+1),ones(2,1)*yBinMeans(k),'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
        plot(xThresholds(k:k+1),ones(2,1)*(yBinMeans(k)+yBinStds(k)),'LineStyle','--',...
            'LineWidth',theLineWidth,'Color',theColor)
        plot(xThresholds(k:k+1),ones(2,1)*(yBinMeans(k)-yBinStds(k)),'LineStyle','--',...
            'LineWidth',theLineWidth,'Color',theColor)
        ph = plot(mean(xThresholds(k:k+1)),yBinMeans(k),'o','MarkerSize',5,'LineStyle',theStyle,...
            'LineWidth',theLineWidth,'Color',theColor);
    end
end
xlim([0 xThresholds(end)])

end
