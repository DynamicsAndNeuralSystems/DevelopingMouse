function [distances_all,corrCoeff_all] = LoadMyDistanceCGE(params,timePointNow)
% Load distances and pre-computed CGE values for a given set of parameters
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Get components of the necessary filename:
[] = LoadSubset(params,timePointNow);

%-------------------------------------------------------------------------------
% Load the data from file:
load(fileString,'distances_all','corrCoeff_all');

%-------------------------------------------------------------------------------
% Normalize distances from um to mm:
if params.distancesMM & ~params.scaledDistance
    distances_all = cellfun(@(x)x/1000,distances_all,'UniformOutput',false);
end

end
