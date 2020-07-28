function maxDistance = getMaxDistance(timePointNow)
% Along x-axis
%-------------------------------------------------------------------------------

timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints));
resolutionGrid = GiveMeParameter('resolutionGrid');

% Get the max extent along the (default x)-axis:
dimension = 1; % x-axis
fileName = GiveMeFileName(timePointNow);
load(fileName,'coOrds','voxLabelTable');
brainVoxels = voxLabelTable.isBrain;
maxX = max(coOrds(brainVoxels,dimension)) - min(coOrds(brainVoxels,dimension));
maxDistance = maxX*resolutionGrid.(timePointNow);

end
