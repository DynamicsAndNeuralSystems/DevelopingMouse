function [maxDistance] = getMaxDistance(timePointNow)
  x = GiveMeParameter('sizeGrids');
  y = GiveMeParameter('resolutionGrid');
  maxDistance = x.(timePointNow)(1)*y.(timePointNow);
