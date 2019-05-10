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
smallCellTypes = GiveMeParameter('smallCellTypes');
for j=1:length(smallBrainDivisions)
  for k=1:length(smallCellTypes)
  makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
                          smallBrainDivisions{j},smallCellTypes{k});
  end
end
