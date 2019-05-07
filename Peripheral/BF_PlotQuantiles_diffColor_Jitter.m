function [f,F] = BF_PlotQuantiles_diffColor_Jitter(xData,yData,dataCell,...
                                    colorScheme,timePointNow)
% Plots x-y scatter, but with mean of y plotted in quantiles of x
% Ben Fulcher
%-------------------------------------------------------------------------------
if nargin < 5
    alsoScatter = 0;
end

numThresholds=length(dataCell);
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
% yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
% yStds = arrayfun(@(x)std(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);

% ------------------------------------------------------------------------------
% Plot:
f = figure('color','w','Position',get(0,'Screensize')); box('on');

hold on
%theColor = 'k';
theStyle = '-';
theLineWidth = 2;
theColor = colorScheme(timePointIndex,:);
offsetRange = 100;
% cmapOut = BF_getcmap('dark2',7,0,0);
% if alsoScatter
%     nodeSize = 10;
%     s=scatter(xData,yData,nodeSize,colorScheme(timePointIndex,:),'LineWidth',0.3);
%     set(s,'Marker','.')
% end

for k = 1:numThresholds-1
    % if doveTail
    %     xRand = zeros(length(dataCell{i}),1);
    %     for j = 1:length(dataCell{i})
    %         try
    %             xRand(j) = (rand(1)*offsetRange-offsetRange/2)*ff{i}(find(xx{i} >= dataCell{i}(j),1));
    %         end
    %     end
    %     %i + rand([length(dataCell{i}),1])*offsetRange-offsetRange/2;
    % else
    %     xRand = rand([length(dataCell{i}),1])*offsetRange-offsetRange/2;
    % end
    xRand = rand([length(dataCell{k}),1])*offsetRange-offsetRange/2;
    plot(mean(xThresholds(k:k+1))+xRand,dataCell{k},'.','color',theColor)
    % plot means
    plot([mean(xThresholds(k:k+1)) - offsetRange/2,...
          mean(xThresholds(k:k+1)) + offsetRange/2],...
          nanmean(dataCell{k})*ones(2,1),'-',...
          'color','k','LineWidth',5)
end

% for k = 1:numThresholds-1
%     plot(xThresholds(k:k+1),ones(2,1)*yMeans(k),'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
%     plot(xThresholds(k:k+1),ones(2,1)*(yMeans(k)+yStds(k)),'LineStyle','--','LineWidth',theLineWidth,'Color',theColor)
%     plot(xThresholds(k:k+1),ones(2,1)*(yMeans(k)-yStds(k)),'LineStyle','--','LineWidth',theLineWidth,'Color',theColor)
%     plot(mean(xThresholds(k:k+1)),yMeans(k),'o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
% end
yPosition=linspace(1,0.4,length(timePoints));
t=text(0.5,0.5,char(timePoints{timePointIndex}),'color','k','FontSize',14,'BackgroundColor',...
        colorScheme(timePointIndex,:));
t.Units='normalized';
t.Position=[1 yPosition(timePointIndex)];
str=sprintf('Developing Mouse %s binning with threshold number=%d',timePointNow,numThresholds);
title(str,'Fontsize',18)
F=getframe(f);
end
