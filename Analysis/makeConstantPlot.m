function makeConstantPlot(numData,numThresholds,thisBrainDiv,...
                          scaledDistance,thisCellType,thisDirection,...
                          makeNewFigure,whatConstantOut)
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
  [fitting_stat_all,constantOut,~] = makeBinnedFitting(xPlotDataAll,...
                                                        yPlotDataAll,...
                                                        numThresholds,...
                                                        whatConstantOut);
  % get the original (unscaled) max distance for plotting
  maxDistance = zeros(length(timePoints),1);
  for i=1:length(timePoints)
    maxDistance(i) = max(xPlotDataAll{i});
  end
else
  [fitting_stat_all,constantOut,maxDistance] = makeBinnedFitting(xPlotDataAll,...
                                                                yPlotDataAll,...
                                                                numThresholds,...
                                                                whatConstantOut);
end

plotConstant(fitting_stat_all,constantOut,whatConstantOut,maxDistance,...
            thisBrainDiv,numData,numThresholds,makeNewFigure,...
            thisDirection,thisCellType);
end
