function makeConstantPlot(numData,numThresholds,thisBrainDiv,...
                          scaledDistance,thisCellType,thisDirection,...
                          makeNewFigure,whatConstantOut,allGrey,...
                          linearRegress,showCorrCoeff,forceYLim,displayAdjR)
% plot decay constant against max distance
% numData=1000;
% numThresholds=20;
% thisBrainDiv='wholeBrain';
% scaledDistance=false;
% thisCellType='allCellTypes';
% thisDirection='allDirections';
% makeNewFigure = true;
% whatConstantOut = 'decayConstant';
% allGrey = false;
% linearRegress = true;
% showCorrCoeff = false;
% forceYLim = false;

timePoints = GiveMeParameter('timePoints');
resolutionGrid = GiveMeParameter('resolutionGrid');
constantTypes = GiveMeParameter('constantTypes');
maxDistance = zeros(length(timePoints),1);
[xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(numData,...
                                                            numThresholds,...
                                                            thisBrainDiv,...
                                                            scaledDistance,...
                                                            thisCellType,...
                                                            thisDirection);
% get max distance
for i=1:length(timePoints)
  maxDistance(i) = getMaxDistance('wholeBrain',timePoints{i});
end

[fitting_stat_all, constantOut] = getFitting(xPlotDataAll,yPlotDataAll,whatConstantOut);

plotConstant(fitting_stat_all,constantOut,whatConstantOut,maxDistance,...
            thisBrainDiv,numData,numThresholds,makeNewFigure,...
            thisDirection,thisCellType,allGrey,linearRegress,...
            showCorrCoeff,forceYLim,displayAdjR);
end
