function makeExponentialPlot_enrichedGenes(numData,numThresholds,scaledDistance,thisCellType)
if scaledDistance
  filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                num2str(numThresholds),'_',thisCellType,'_scaled','.mat');
  filestr2=strcat('fitting_NumData_',num2str(numData),...
                '_binnedData_numThresholds_',num2str(numThresholds),...
                '_',thisCellType,'_scaled','.mat');
else
  filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                num2str(numThresholds),'_',thisCellType,'.mat');
  filestr2=strcat('fitting_NumData_',num2str(numData),...
                '_binnedData_numThresholds_',num2str(numThresholds),...
                '_',thisCellType,'.mat');
end
load(filestr1);
load(filestr2);
% exponential fit (3 term) on same plot (voxel data)
if scaledDistance
  xLabeling='Separation Distance/maxDistance';
else
  xLabeling='Separation Distance (um)';
end
[~,F]= plotFitting(xPlotDataAll,'exp',fitting_stat_all,'voxel',...
                  xLabeling,1,'original','allDirections','wholeBrain',thisCellType);

if scaledDistance
  str=fullfile('Outs',strcat('exponential_plot_all_',thisCellType,'_scaled'),...
              strcat('exponential_plot_all_',thisCellType,'_scaled','.jpeg'));
else
  str=fullfile('Outs',strcat('exponential_plot_all_',thisCellType),...
              strcat('exponential_plot_all_',thisCellType,'.jpeg'));
end

imwrite(F.cdata, str, 'jpeg');
end
