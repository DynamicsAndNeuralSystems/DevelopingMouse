function [distances_all,corrCoeff_all] = LoadMyDistanceCGE(params)
% Load distances and pre-computed CGE values for a given set of parameters
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Get components of the necessary filename:
brainStr = GiveMeFileName(params.thisBrainDiv);
cellTypeStr = GiveMeFileName(params.thisCellType);
if params.scaledDistance
    distanceStr = GiveMeFileName('scaled');
else
    distanceStr = GiveMeFileName('notScaled');
end
if strcmp(params.thisDirection,'allDirections')
    fileString = sprintf('spatialData_NumData_%d%s%s%s.mat',params.numData,brainStr,cellTypeStr,...
                    distanceStr);
else
    fileString = sprintf('directionalityData_%s%s.mat',params.thisDirection,distanceStr);
end

%-------------------------------------------------------------------------------
% Load the data from file:
load(fileString,'distances_all','corrCoeff_all');

%-------------------------------------------------------------------------------
% Normalize distances from um to mm:
if params.distancesMM
    distances_all = cellfun(@(x)x/1000,distances_all,'UniformOutput',false);
end

end
