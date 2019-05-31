function createData(fromScratch)
% create most of the data; if fromScratch is true, creates data starting from raw data; otherwise,
% create data starting from energyGrids matlab variables
whatNorm=GiveMeParameter('whatNorm');
whatVoxelThreshold=GiveMeParameter('whatVoxelThreshold');
whatGeneThreshold=GiveMeParameter('whatGeneThreshold');
numData=GiveMeParameter('numData');

if nargin < 1
  fromScratch = false;
end

if fromScratch
  renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData);
else
  renderDataFromEnergyGrids(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData)
end
end
