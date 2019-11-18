function [fitting_stat_all,constantOut]=makeBinnedFitting(xPlotDataAll,yPlotDataAll,numThresholds,whatConstantOut)
% fits binned data with exponential, outputting fitting stats, decay constant and maxDistance

% create fitting
[fitting_stat_all, constantOut] = getFitting(xPlotDataAll,yPlotDataAll,whatConstantOut);

end
