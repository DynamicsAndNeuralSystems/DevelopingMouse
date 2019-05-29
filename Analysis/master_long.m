% master script that runs the entire good gene workflow
whatNorm='scaledSigmoid';
whatVoxelThreshold=0.3;
whatGeneThreshold=0.3;
numData=1000;
numThresholds=21;
incrementVector=100:100:1000;
samplingNum=100;
% ------------------------------------------------------------------------------
% Process raw data from Allen API
% ------------------------------------------------------------------------------
renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData)

% create the data of variance in decay constant against number of data points used ...
% (takes very long)
% makeVariance(incrementVector,samplingNum); % comment out for the time being
% ------------------------------------------------------------------------------
% Make the figures
makeFigure1(numData,numThresholds);
makeFigure2(numData,numThresholds);
makeFigure3(numData,numThresholds);
makeFigure4(numData,numThresholds);
makeFigure5(numData,numThresholds);
makeFigureS1();
makeFigureS2(numData,numThresholds);
