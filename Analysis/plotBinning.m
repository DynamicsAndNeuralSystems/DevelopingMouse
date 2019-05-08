function [xPlotDataAll,yPlotDataAll,yStdsAll] = plotBinning(xData_all,yData_all,numThresholds)
  % xData_all and yData_all are cells containing data from all time points
  % F is the getframe object for setting figure saving size
  timePoints=GiveMeParameter('timePoints');
  xPlotDataAll=cell(length(timePoints),1);
  yPlotDataAll=cell(length(timePoints),1);
  yStdsAll=cell(length(timePoints),1);
  for i=1:length(timePoints)
      xData=xData_all{i};
      yData=yData_all{i};
      xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
      xThresholds(end) = xThresholds(end) + eps;
      yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
      yStds = arrayfun(@(x)std(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),...
                        1:numThresholds-1);

      xPlotDataAll{i}=zeros(numThresholds-1,1);
      yPlotDataAll{i}=zeros(numThresholds-1,1);
      yStdsAll{i}=zeros(numThresholds-1,1);

      for g = 1:numThresholds-1
          xPlotDataAll{i}(g)=mean(xThresholds(g:g+1));
          yPlotDataAll{i}(g)=yMeans(g);
          yStdsAll{i}(g)=yStds(g);
          hold on
      end
  end
end
