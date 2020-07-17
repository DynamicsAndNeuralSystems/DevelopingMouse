function [distMat,cgeMat] = ComputeDistanceCGE(params,timePointNow)
% Load distances and pre-computed CGE values for a given set of parameters
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Get components of the necessary filename:
[voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);

%-------------------------------------------------------------------------------
% Compute pairwise distances:
fprintf(1,'Computing euclidean distances from coordinates...\n');
resolutionGrid = GiveMeParameter('resolutionGrid');
distMat = pdist(coOrds,'euclidean') * resolutionGrid.(timePointNow);

% Normalize distances from um to mm:
if params.distancesMM & ~params.scaledDistance
    distMat = distMat/1000;
end
% To matrix form:
distMat = squareform(distMat);
fprintf(1,'%ux%u\n',size(distMat,1),size(distMat,2));

%-------------------------------------------------------------------------------
% Compute CGE:
fprintf(1,'Computing CGE...\n');
cgeMat = corr(voxelGeneExpression','type',params.whatCorr,'rows','pairwise');

end
