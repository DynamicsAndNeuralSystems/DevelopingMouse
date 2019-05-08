function [fitting_stat_all,decayConstant,maxDistance]=makeBinnedFitting(xPlotDataAll,...
                                                                        yPlotDataAll,...
                                                                        numThresholds)
% fits binned data with exponential, outputting fitting stats, decay constant and maxDistance

% create fitting
[fitting_stat_all, decayConstant, maxDistance]=getFitting(xPlotDataAll,yPlotDataAll);

end
