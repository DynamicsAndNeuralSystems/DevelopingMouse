function [maxDistance] = getMaxDistance(thisBrainDiv,timePointNow,dimension)
  % dimension is either 1, 2 or 3 (corresponding to the x, y and z dimensions respecitvely)
  if nargin < 3
    dimension = 1;
  end
  load('annotationGrids.mat');
  timePoints = GiveMeParameter('timePoints');
  timePointIndex = find(strcmp(timePointNow,timePoints));
  resolutionGrid = GiveMeParameter('resolutionGrid');
  % get the max extent along the x-axis
  coOrds = getCoOrds(thisBrainDiv,timePointNow);
  maxX = max(coOrds(:,dimension)) - min(coOrds(:,dimension));
  maxDistance = maxX*resolutionGrid.(timePointNow);
end
