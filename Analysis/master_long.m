% master script that runs the entire good gene workflow
whatNorm=GiveMeParameter('whatNorm');
whatVoxelThreshold=GiveMeParameter('whatVoxelThreshold');
whatGeneThreshold=GiveMeParameter('whatGeneThreshold');
numData=GiveMeParameter('numData');
numThresholds=GiveMeParameter('numThresholds');
incrementVector=GiveMeParameter('incrementVector');
samplingNum=GiveMeParameter('samplingNum');
% ------------------------------------------------------------------------------
% Process raw data from Allen API
% ------------------------------------------------------------------------------
% create most of the data
% renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData);

% uncomment and use this instead if starting with energyGrids
renderDataFromEnergyGrids(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData);

% create the data of variance in decay constant against number of data points used ...
% (takes very long)
makeVariance(incrementVector,samplingNum);

% ------------------------------------------------------------------------------
% Make the figures
makeFigure1(numData,numThresholds);
makeFigure2(numData,numThresholds);
makeFigure3(numData,numThresholds);
makeFigure4(numData,numThresholds);
makeFigure5(numData,numThresholds);
makeFigureS1();
makeFigureS2(numData,numThresholds);
