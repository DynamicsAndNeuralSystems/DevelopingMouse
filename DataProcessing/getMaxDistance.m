function maxDistance = getMaxDistance(thisBrainDiv,timePointNow)
% Along x-axis

load('annotationGrids.mat');
timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints));
resolutionGrid = GiveMeParameter('resolutionGrid');

% Get the max extent along the (default x)-axis:
coOrds = getCoOrds(thisBrainDiv,timePointNow);
maxX = max(coOrds(:,dimension)) - min(coOrds(:,dimension));
maxDistance = maxX*resolutionGrid.(timePointNow);

end
