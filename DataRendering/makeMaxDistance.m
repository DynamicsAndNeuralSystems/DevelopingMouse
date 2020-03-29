function [maxDistanceMat] = makeMaxDistance(dimension)
  if nargin < 1
    dimension = 1;
  end
  timePoints = GiveMeParameter('timePoints');
  thisBrainDiv = 'wholeBrain';
  maxDistanceMat = zeros(length(timePoints),1);
  for i=1:length(timePoints)
    maxDistanceMat(i) = getMaxDistance(thisBrainDiv,timePoints{i},dimension);
  end
end
