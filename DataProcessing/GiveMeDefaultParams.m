function params = GiveMeDefaultParams()

% Data:
params.thisBrainDiv = 'brain'; %'wholeBrain';
params.doSubsample = true; % analyze just a subsample of numData voxels
params.thisCellType = 'allCellTypes';
params.scaledDistance = false;
params.thisDirection = 'allDirections';
params.distancesMM = false; % rescale distances by a factor of 1000

% Info:
params.includeAdult = true;
params.timePoints = GiveMeParameter('timePoints');
params.adultCoronal = true; % Adult coronal data used: true; Adult sagittal data used: false
if ~params.includeAdult
    fprintf(1,'Looking at developmental data (up to P28)\n');
    params.timePoints = params.timePoints(1:end-1);
end

%-------------------------------------------------------------------------------
params.numData = 1000; % must re-run AnnotateAllSamples to re-sample
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
params.colors = BF_getcmap('dark2',8,0);

end
