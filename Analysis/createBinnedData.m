clear
filestr='spatialData_NumData_1000';
load(strcat(filestr,'.mat'));
C=strsplit(filestr,'_');
numData=C{3};
numThresholds=100;
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
xPlotDataAll_scaled=cell(length(timePoints),1);
% Bin
[~,~,xPlotDataAll,yPlotDataAll] = plotBinning(distances_all,corrCoeff_all,numThresholds);
% Bin and then scale the distance
for i=1:length(timePoints)
  xPlotDataAll_scaled{i}=xPlotDataAll{i}/max(xPlotDataAll{i});
end
% save variable
str=fullfile('Matlab_variables',strcat('binnedData_NumData_',numData,'_','numThresholds','_',num2str(numThresholds),'.mat'));
save(str,'xPlotDataAll','yPlotDataAll','xPlotDataAll_scaled','numThresholds')
