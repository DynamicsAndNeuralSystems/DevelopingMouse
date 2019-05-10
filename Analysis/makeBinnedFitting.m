function [fitting_stat_all,constantOut,maxDistance]=makeBinnedFitting(xPlotDataAll,yPlotDataAll,numThresholds,whatConstantOut)
% fits binned data with exponential, outputting fitting stats, decay constant and maxDistance

% create fitting
[fitting_stat_all, constantOut, maxDistance] = getFitting(xPlotDataAll,yPlotDataAll,whatConstantOut);

end
