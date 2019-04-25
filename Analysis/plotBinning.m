function [f,F,xPlotDataAll,yPlotDataAll] = plotBinning(xData_all,yData_all,numThresholds)
  % xData_all and yData_all are cells containing data from all time points
  % F is the getframe object for setting figure saving size
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  xPlotDataAll=cell(length(timePoints),1);
  yPlotDataAll=cell(length(timePoints),1);
  % specify styles
  theStyle = '-';
  theLineWidth = 2;

  % first, get the colours needed
  cmapOut = BF_getcmap('dark2',7,0,0);
  %% second, plot data from different time points in quantiles in the same graph
  f=figure('color','w','Position', get(0, 'Screensize')); % 7 plots, one for each time point

  for i=1:length(timePoints)
      theColor=cmapOut(i,:);
      xData=xData_all{i};
      yData=yData_all{i};
      xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
      xThresholds(end) = xThresholds(end) + eps;
      yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);

      xPlotDataAll{i}=zeros(numThresholds-1,1);
      yPlotDataAll{i}=zeros(numThresholds-1,1);
      for g = 1:numThresholds-1
          xPlotDataAll{i}(g)=mean(xThresholds(g:g+1));
          yPlotDataAll{i}(g)=yMeans(g);
          hold on
      end
      plot(xPlotDataAll{i},yPlotDataAll{i},'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)

      yPosition=linspace(1,0.4,length(timePoints));
      t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
              cmapOut(i,:));
      t.Units='normalized';
      t.Position=[1 yPosition(i)];
      str=sprintf('Developing Mouse binning with threshold number=%d',numThresholds);
      title(str,'Fontsize',18)
      hold on
  end
  xlabel('Separation Distance (um)','FontSize',16)
  ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
  F = getframe(f);
end
