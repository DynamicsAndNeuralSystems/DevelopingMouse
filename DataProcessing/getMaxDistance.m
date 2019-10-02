function [maxDistance] = getMaxDistance(timePointNow)
  x = GiveMeParameter('sizeGrids');
  maxDistance = x.(timePointNow)(1);
