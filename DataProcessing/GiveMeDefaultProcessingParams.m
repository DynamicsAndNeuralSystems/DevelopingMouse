function params = GiveMeDefaultProcessingParams()
% Outputs a set of current default processing parameters:


% whatNorm: must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
params.whatNorm = 'norm';

% thisBrainDiv: 'forebrain', 'midbrain', 'hindbrain' or 'wholeBrain'
params.thisBrainDiv = 'wholeBrain';

parmas.thisCellType = '';

params.whatVoxelThreshold = 0.3;

params.whatGeneThreshold = 0.3;

params.useGoodGeneSubset = true;

end
