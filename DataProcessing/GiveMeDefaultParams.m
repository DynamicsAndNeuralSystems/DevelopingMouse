function params = GiveMeDefaultParams()

% Data:
params.timePoints = GiveMeParameter('timePoints');
params.thisBrainDiv = 'wholeBrain';
params.thisCellType = 'allCellTypes';
params.scaledDistance = false;
params.thisDirection = 'allDirections';
params.distancesMM = false;
params.numData = 1000;
params.constantTypes = GiveMeParameter('constantTypes');

% Fitting:
params.numThresholds = 21;
params.whatFit = 'exp';
params.colors = BF_getcmap('dark2',7,0);

% Info:
params.timePoints = GiveMeParameter('timePoints');

end
