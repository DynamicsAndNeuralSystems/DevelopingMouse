function [distances] = extractDistances(distMat)
distances=distMat(find(triu(ones(size(distMat)),1)));
end
