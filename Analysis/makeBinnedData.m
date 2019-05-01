function [binnedDataCell,binnedAnnotationCell]=makeBinnedData(xData,...
                                                              yData,...
                                                              numThresholds,...
                                                              annotation_pair)
% separate data into bins
xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
xThresholds(end) = xThresholds(end) + eps; % make sure all data included in final bin
binnedDataCell=cell(numThresholds,1);
binnedAnnotationCell=cell(numThresholds,1);
k=1;
for j=1:numThresholds-1
  binnedDataCell{j}=yData(xData>=xThresholds(j) & xData < xThresholds(j+1));
  binnedAnnotationCell{j}=annotation_pair(k:(k+length(binnedDataCell{j})-1));
  k=k+length(binnedDataCell{j});
end
end
