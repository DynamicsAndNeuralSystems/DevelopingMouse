function [dist,CGE,voxInfo,geneInfo] = ComputeDistanceCGE(params,timePointNow,makeVector)
% Load distances and pre-computed CGE values for a given set of parameters
%-------------------------------------------------------------------------------

if nargin < 1
    params = GiveMeDefaultParams();
end
if nargin < 2
    timePointNow = 'E11pt5';
end
if nargin < 3
    makeVector = false;
end

%-------------------------------------------------------------------------------
% Get components from the appropriate file:
[voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);
if any(size(voxelGeneExpression)==0)
    dist = NaN;
    CGE = NaN;
    warning('No good data at %s',timePointNow)
    return
end

%-------------------------------------------------------------------------------
% Compute pairwise distances:
fprintf(1,'Computing euclidean distances from coordinates...\n');
resolutionGrid = GiveMeParameter('resolutionGrid');
dist = pdist(coOrds,'euclidean') * resolutionGrid.(timePointNow);

% Normalize distances from um to mm:
if params.distancesMM & ~params.scaledDistance
    dist = dist/1000;
end
% To matrix form:
dist = squareform(dist);
fprintf(1,'%ux%u\n',size(dist,1),size(dist,2));

%-------------------------------------------------------------------------------
% Compute CGE:
fprintf(1,'Computing CGE...\n');
CGE = corr(voxelGeneExpression','type',params.whatCorr,'rows','pairwise');

%-------------------------------------------------------------------------------
% Take upper triangles as vectors:
if makeVector
    fprintf(1,'Converting to vectors on upper diagonal\n');
    trueDat = true(size(dist));
    dist = dist(triu(trueDat,+1));
    CGE = CGE(triu(trueDat,+1));
end

end
