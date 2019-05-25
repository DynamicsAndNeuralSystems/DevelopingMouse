% this is a temporary script to test the workflow of directionality analysis
whatNorm='scaledSigmoid';
whatVoxelThreshold=0.3;
whatGeneThreshold=0.3;
numData=1000;
numThresholds=21;
incrementVector=100:100:1000;
samplingNum=100;
timePoints = GiveMeParameter('timePoints');
smallBrainDivisions = GiveMeParameter('smallBrainDivisions');
brainDivisions = GiveMeParameter('brainDivisions');
directions = GiveMeParameter('directions');
cellTypes = GiveMeParameter('cellTypes');
smallCellTypes = GiveMeParameter('smallCellTypes');
% make distances and correlation coefficient of 3 directions
for j=1:length(directions)
  makeDirectionalityData(numData,false,directions{j});
end

% plot exponential curves of different directions of different time points together
for j=1:length(directions)
  makeExponentialPlot(numData,numThresholds,...
                      'wholeBrain',false,...
                      directions{j},'allCellTypes',true);
end

% plot decay constant of different directions against max distance
for j=1:length(directions)
  makeConstantPlot(numData,numThresholds,'wholeBrain',...
                          false,'allCellTypes',directions{j},...
                          true,'decayConstant');
end
