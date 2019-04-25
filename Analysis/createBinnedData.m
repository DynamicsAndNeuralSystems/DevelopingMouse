clear
load('fitting.mat','spatialData');
numThresholds=100;
% Bin
[~,~,xPlotDataAll,yPlotDataAll] = plotBinning(spatialData.voxel.distancesAll,...
                                        spatialData.voxel.corrCoeffAll,...
                                        numThresholds);
% save variable
str=fullfile('Matlab_variables',strcat('binnedData','_','numThresholds',num2str(numThresholds),'.mat'));
save(str,'xPlotDataAll','yPlotDataAll','numThresholds')
% Bin and then scale the distance
