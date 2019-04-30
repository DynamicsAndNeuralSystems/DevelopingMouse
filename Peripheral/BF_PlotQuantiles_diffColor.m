function [f,F] = BF_PlotQuantiles_diffColor(xData,yData,numThresholds,alsoScatter,...
                                    colorScheme,makeNewFigure,timePointNow)
% Plots x-y scatter, but with mean of y plotted in quantiles of x
% Ben Fulcher
%-------------------------------------------------------------------------------

if nargin<3
    theColor='k';
end
if nargin < 4 || isempty(numThresholds)
    numThresholds = 10;
end
if nargin < 5
    alsoScatter = 0;
end
if nargin < 6
    makeNewFigure = 0;
end

%-------------------------------------------------------------------------------
% Filter out NaNs:
goodBoth = (~isnan(xData) & ~isnan(yData));
if ~any(goodBoth)
    error('No good data');
elseif any(~goodBoth)
    xData = xData(goodBoth);
    yData = yData(goodBoth);
    fprintf(1,'Removed %u bad samples from x/y data\n',sum(~goodBoth));
end

% parameter for looping
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
timePointIndex=find(cellfun(@(x) strcmp(timePointNow,x), timePoints));
xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
xThresholds(end) = xThresholds(end) + eps; % make sure all data included in final bin
yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
yStds = arrayfun(@(x)std(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);

% ------------------------------------------------------------------------------
% Plot:
if makeNewFigure
    f = figure('color','w','Position',get(0,'Screensize')); box('on');
else
    f = NaN;
end
hold on
%theColor = 'k';
theStyle = '-';
theLineWidth = 2;
theColor = colorScheme(timePointIndex,:);
% cmapOut = BF_getcmap('dark2',7,0,0);
if alsoScatter
    nodeSize = 10;
    s=scatter(xData,yData,nodeSize,colorScheme(timePointIndex,:),'LineWidth',0.3);
    set(s,'Marker','.')
end

for k = 1:numThresholds-1
    plot(xThresholds(k:k+1),ones(2,1)*yMeans(k),'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
    plot(xThresholds(k:k+1),ones(2,1)*(yMeans(k)+yStds(k)),'LineStyle','--','LineWidth',theLineWidth,'Color',theColor)
    plot(xThresholds(k:k+1),ones(2,1)*(yMeans(k)-yStds(k)),'LineStyle','--','LineWidth',theLineWidth,'Color',theColor)
    plot(mean(xThresholds(k:k+1)),yMeans(k),'o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
end
yPosition=linspace(1,0.4,length(timePoints));
t=text(0.5,0.5,char(timePoints{timePointIndex}),'color','k','FontSize',14,'BackgroundColor',...
        colorScheme(timePointIndex,:));
t.Units='normalized';
t.Position=[1 yPosition(timePointIndex)];
str=sprintf('Developing Mouse %s binning with threshold number=%d',timePointNow,numThresholds);
title(str,'Fontsize',18)
if makeNewFigure
    F=getframe(f);
else
    F=NaN;
end
