clear
load('fitting.mat','spatialData');
numThresholds=100;
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
xPlotDataAll_scaled=cell(length(timePoints),1);
% Bin
[~,~,xPlotDataAll,yPlotDataAll] = plotBinning(spatialData.voxel.distancesAll,...
                                        spatialData.voxel.corrCoeffAll,...
                                        numThresholds);
% Bin and then scale the distance
for i=1:length(timePoints)
  xPlotDataAll_scaled{i}=xPlotDataAll{i}/max(xPlotDataAll{i});
end
% save variable
str=fullfile('Matlab_variables',strcat('binnedData','_','numThresholds',num2str(numThresholds),'.mat'));
save(str,'xPlotDataAll','yPlotDataAll','xPlotDataAll_scaled','numThresholds')
