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
% comment out for the time being
% renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData)

% create the data of variance in decay constant against number of data points used ...
% (takes very long)
% comment out for the time being
% makeVariance(incrementVector,samplingNum);

% temporary placed here
% cell types, using good gene subset
createSpatialData(numData,false);

% ------------------------------------------------------------------------------
% Make the figures
makeFigure1(numData,numThresholds);
makeFigure2(numData,numThresholds);
makeFigure3(numData,numThresholds);
makeFigure4(numData,numThresholds);
makeFigure5(numData,numThresholds);
makeFigureS1();
makeFigureS2(numData,numThresholds);
