function makeDecayConstantFit(numData,numThresholds,thisBrainDiv,...
                              thisCellType,thisDirection,...
                              scaledDistance,logPlot,makeNewFigure)
timePoints=GiveMeParameter('timePoints');
[xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(numData,...
                                                            numThresholds,...
                                                            thisBrainDiv,...
                                                            scaledDistance,...
                                                            thisCellType,...
                                                            thisDirection);

[~,decayConstant,maxDistance] = makeBinnedFitting(xPlotDataAll,...
                                                  yPlotDataAll,...
                                                  numThresholds);
if makeNewFigure
  f=figure('color','w','Position',get(0,'Screensize'));
end
axis square
if logPlot
  xLabel = GiveMeLabelName('logLength');
  yLabel = GiveMeLabelName('logDecayConstant');
else
  xLabel = GiveMeLabelName('length');
  yLabel = GiveMeLabelName('decayConstant');
end
xlabel(xLabel);
ylabel(yLabel);
hold on
if logPlot
  xData=log(maxDistance);
  yData=log(decayConstant);
else
  xData=maxDistance;
  yData=decayConstant;
end
% plot the data points
plot(xData,yData,'ok','DisplayName','Eta');
% fit and plot it
[f_handle,stats,c]=GiveMeFit(xData,yData,'linear');
Gradient = c.p1; Intercept = c.p2;
if logPlot
  plot(linspace(8.2,9.799,7),f_handle(linspace(8.2,9.799,7)),'DisplayName','linear');
else
  plot(linspace(0,12000,5),f_handle(linspace(0,12000,5)),'DisplayName','linear');
end

str=sprintf('y = %fx+%f',Gradient,Intercept);
text(5000,12,str);
str=sprintf('Adjusted R square = %d',stats.adjrsquare);
text(5000,11,str);

legend('show')

end
