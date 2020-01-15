function [xPlotDataAll,yPlotDataAll] = makeBinnedData(params)
% Bins the CGE-distance data into numThresholds-1 bins
%-------------------------------------------------------------------------------

% Load the spatial data from file:
[distances_all,corrCoeff_all] = LoadMyDistanceCGE(params);

% Bin the data
[xPlotDataAll,yPlotDataAll,~] = plotBinning(distances_all,corrCoeff_all,params.numThresholds);

end
