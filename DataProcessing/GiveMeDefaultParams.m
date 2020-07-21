function params = GiveMeDefaultParams()

% Data:
params.timePoints = GiveMeParameter('timePoints');
params.thisBrainDiv = 'brain'; %'wholeBrain';
params.doSubsample = false; % analyze just a subsample of numData voxels
params.thisCellType = 'allCellTypes';
params.scaledDistance = false;
params.thisDirection = 'allDirections';
params.distancesMM = false;
params.numData = 1000;
params.constantTypes = GiveMeParameter('constantTypes');
params.whatCorr = 'Pearson';

% Filtering/normalization:
params.usePersistentGenes = false;
params.whatNorm = 'scaledRobustSigmoid';
params.whatVoxelThreshold = 0.3;
params.whatGeneThreshold = 0.3;

% Fitting:
params.numThresholds = 21;
params.whatFit = 'exp';
params.colors = BF_getcmap('dark2',7,0);

% Info:
params.timePoints = GiveMeParameter('timePoints');

end
