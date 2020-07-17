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
distMat = squareform(pdist(coOrds,'euclidean')) * resolutionGrid.(timePointNow);

% Normalize distances from um to mm:
if params.distancesMM & ~params.scaledDistance
    distances_all = cellfun(@(x)x/1000,distMat,'UniformOutput',false);
end

%-------------------------------------------------------------------------------
% Compute CGE:
fprintf(1,'Computing CGE...\n');
cgeMat = corr(voxelGeneExpression','type',params.whatCorr,'rows','pairwise');

end
