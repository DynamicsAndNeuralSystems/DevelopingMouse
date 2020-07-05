function createData(fromScratch,thisBrainDiv)
% create most of the data; if fromScratch is true, creates data starting from raw data; otherwise,
% create data starting from energyGrids matlab variables

if nargin < 2
    thisBrainDiv = 'wholeBrain';
end
if nargin < 1
    fromScratch = false;
end

% Load default parameters:
whatNorm=GiveMeParameter('whatNorm');
whatVoxelThreshold=GiveMeParameter('whatVoxelThreshold');
whatGeneThreshold=GiveMeParameter('whatGeneThreshold');
numData=GiveMeParameter('numData');

if fromScratch
    renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData,thisBrainDiv);
else
    renderDataFromEnergyGrids(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData,thisBrainDiv);
end

end
