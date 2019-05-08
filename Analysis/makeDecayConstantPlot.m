function makeDecayConstantPlot(numData,numThresholds,thisBrainDiv,...
                              scaledDistance,thisCellType,thisDirection,...
                              makeNewFigure)
% numData=1000;
% numThresholds=20;
% useGoodGeneSubset=true;
% thisBrainDiv='wholeBrain';
% scaledDistance=false;
% plot decay constant against max distance
timePoints = GiveMeParameter('timePoints');
[xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(numData,...
                                                            numThresholds,...
                                                            thisBrainDiv,...
                                                            scaledDistance,...
                                                            thisCellType,...
                                                            thisDirection);
if scaledDistance
  [fitting_stat_all,decayConstant,~] = makeBinnedFitting(xPlotDataAll,...
                                                        yPlotDataAll,...
                                                        numThresholds);
  % get the original (unscaled) max distance for plotting
  maxDistance = zeros(length(timePoints),1);
  for i=1:length(timePoints)
    maxDistance(i) = max(xPlotDataAll{i});
  end
else
  [fitting_stat_all,decayConstant,maxDistance] = makeBinnedFitting(xPlotDataAll,...
                                                                  yPlotDataAll,...
                                                                  numThresholds);
end

plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,...
                  thisBrainDiv,numData,numThresholds,makeNewFigure,...
                  thisDirection,thisCellType);
end
