whatNorm='scaledSigmoid';
whatVoxelThreshold=0.3;
whatGeneThreshold=0.3;
numData=1000;
numThresholds=20;
incrementVector=100:100:1000;
samplingNum=100;
timePoints = GiveMeParameter('timePoints');
smallBrainDivisions = GiveMeParameter('smallBrainDivisions');
brainDivisions = GiveMeParameter('brainDivisions');
directions = GiveMeParameter('directions');
cellTypes = GiveMeParameter('cellTypes');

for j=1:length(brainDivisions)
  f=figure('color','w');
  for k=1:length(cellTypes)
    makeConstantPlot(numData,numThresholds,brainDivisions{j},...
                    false,cellTypes{k},'allDirections',...
                    false,'decayConstant');
  end
end
