function [maxDistanceMat] = makeMaxDistance()
  timePoints = GiveMeParameter('timePoints');
  thisBrainDiv = 'wholeBrain';
  maxDistanceMat = zeros(length(timePoints),1);
  for i=1:length(timePoints)
    maxDistanceMat(i) = getMaxDistance(thisBrainDiv,timePoints{i});
  end
end
