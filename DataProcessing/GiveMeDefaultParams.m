function params = GiveMeDefaultParams()

% Data:
params.timePoints = GiveMeParameter('timePoints');
params.thisBrainDiv = 'wholeBrain';
params.thisCellType = 'allCellTypes';
params.scaledDistance = false;
params.thisDirection = 'allDirections';
params.distancesMM = true;

% Fitting:
params.numThresholds = 21;

% Info:
params.timePoints = GiveMeParameter('timePoints');

end
