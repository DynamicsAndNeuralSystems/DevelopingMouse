function [distances] = computeDistances(distMat)
distances=distMat(find(triu(ones(size(distMat)),1)));
