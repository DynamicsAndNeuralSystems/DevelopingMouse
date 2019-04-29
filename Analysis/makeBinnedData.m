function [binnedDataCell]=makeBinnedData(xData,yData,numThresholds)
% separate data into bins
xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
xThresholds(end) = xThresholds(end) + eps; % make sure all data included in final bin
binnedDataCell=cell(numThresholds,1);
for j=1:numThresholds-1
  binnedDataCell{j}=yData(xData>=xThresholds(j) & xData < xThresholds(j+1));
end
end
