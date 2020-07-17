function params = GiveMeDefaultProcessingParams_delete()
% Outputs a set of current default processing parameters:

% whatNorm: must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
params.whatNorm = GiveMeParameter('whatNorm');

% thisBrainDiv: 'forebrain', 'midbrain', 'hindbrain' or 'wholeBrain'
params.thisBrainDiv = 'wholeBrain';

params.thisCellType = 'allCellTypes';

params.numData = GiveMeParameter('numData');

params.whatVoxelThreshold = 0.3;
params.whatGeneThreshold = 0.3;

params.useGoodGeneSubset = false;

params.withDirection = false;

params.scaledDistance = GiveMeParameter('scaledDistance');

end
