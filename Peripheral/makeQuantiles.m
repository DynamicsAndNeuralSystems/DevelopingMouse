function [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(xData,yData,numThresholds)
%-------------------------------------------------------------------------------

if nargin < 2
    % Just get the x data:
    yData = [];
end
if nargin < 3 || isempty(numThresholds)
    numThresholds = 10;
end

%-------------------------------------------------------------------------------
% Filter out NaNs:
if ~isempty(yData)
    goodBoth = (~isnan(xData) & ~isnan(yData));
else
    goodBoth = ~isnan(xData);
end

if ~any(goodBoth)
    error('No good data');
elseif any(~goodBoth)
    xData = xData(goodBoth);
    yData = yData(goodBoth);
    fprintf(1,'Removed %u bad samples from x/y data\n',sum(~goodBoth));
end

% BIN X-DATA:
xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
xThresholds(end) = xThresholds(end) + eps; % make sure all data included in final bin
xBinCenters = mean([xThresholds(1:end-1);xThresholds(2:end)]);

assert(length(unique(xThresholds))==length(xThresholds));

% SUMMARIZE Y-DATA WITHIN EACH BIN:
if ~isempty(yData)
    yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
    yMedians = arrayfun(@(x)median(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
    yStds = arrayfun(@(x)std(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
end

% Ensure column vectors:
if size(xBinCenters,2) > size(xBinCenters,1)
    xBinCenters = xBinCenters';
end
if size(yMeans,2) > size(yMeans,1)
    yMeans = yMeans';
end

end
