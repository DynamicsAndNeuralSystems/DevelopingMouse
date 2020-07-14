function params = GiveMeDefaultProcessingParams()
% Outputs a set of current default processing parameters:

% whatNorm: must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
params.whatNorm = whatNorm = GiveMeParameter('whatNorm');

% thisBrainDiv: 'forebrain', 'midbrain', 'hindbrain' or 'wholeBrain'
params.thisBrainDiv = 'wholeBrain';

params.thisCellType = '';

params.numData = GiveMeParameter('numData');

params.whatVoxelThreshold = GiveMeParameter('whatVoxelThreshold');

params.whatGeneThreshold = GiveMeParameter('whatGeneThreshold');

params.useGoodGeneSubset = true;

params.withDirection = false;

params.scaledDistance = GiveMeParameter('scaledDistance');

end
