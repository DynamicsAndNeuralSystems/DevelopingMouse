function PlotQuantiles_diffColor(xData,yData,numThresholds,alsoScatter,...
                                          theColor,makeNewFigure)
% Plots x-y scatter, but with mean of y plotted in quantiles of x
%-------------------------------------------------------------------------------
if nargin < 3 || isempty(numThresholds)
    numThresholds = 10;
end
if nargin < 4
    alsoScatter = false;
end
if nargin < 5
    makeNewFigure = false;
end

%-------------------------------------------------------------------------------
% Binning:
[xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(params);

%-------------------------------------------------------------------------------
% Parameter for looping

xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
xThresholds(end) = xThresholds(end) + eps; % make sure all data included in final bin
yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),...
                  1:numThresholds-1);
yStds = arrayfun(@(x)std(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),...
                  1:numThresholds-1);

% ------------------------------------------------------------------------------
% Plot:
if makeNewFigure
    f = figure('color','w'); box('on');
end

hold('on')
theStyle = '-';
theLineWidth = 1;
theColor = colorScheme(timePointIndex,:);
% cmapOut = BF_getcmap('dark2',7,0,0);
if alsoScatter
    nodeSize = 10;
    s=scatter(xData,yData,nodeSize,colorScheme(timePointIndex,:),'LineWidth',0.3);
    set(s,'Marker','.')
end

for k = 1:numThresholds-1
    plot(xThresholds(k:k+1),ones(2,1)*yMeans(k),'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
    plot(xThresholds(k:k+1),ones(2,1)*(yMeans(k)+yStds(k)),'LineStyle','--',...
        'LineWidth',theLineWidth,'Color',theColor)
    plot(xThresholds(k:k+1),ones(2,1)*(yMeans(k)-yStds(k)),'LineStyle','--',...
        'LineWidth',theLineWidth,'Color',theColor)
    plot(mean(xThresholds(k:k+1)),yMeans(k),'o','MarkerSize',5,'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
end
xlim([0 xThresholds(end)])
% yPosition=linspace(1,0.4,length(timePoints));
% t=text(0.5,0.5,char(timePoints{timePointIndex}),'color','k',...
%       'BackgroundColor',colorScheme(timePointIndex,:));
% t.Units='normalized';
% t.Position=[1 yPosition(timePointIndex)];

end
