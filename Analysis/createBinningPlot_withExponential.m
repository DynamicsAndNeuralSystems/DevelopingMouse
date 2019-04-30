timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('spatialData_NumData_1000.mat');
filestr='fitting_NumData_1000_binnedData_numThresholds_20';
load(strcat(filestr,'.mat'));
file_parts=strsplit(filestr,'_');
numThresholds=str2num(file_parts{6});
% [~,F,~,~]=plotBinning(distances_all,corrCoeff_all,20)
cmapOut = BF_getcmap('dark2',7,0,0);
for i=1:length(timePoints)
  f = figure('color','w','Position',get(0,'Screensize')); box('on');
  [~,~] = BF_PlotQuantiles_diffColor(distances_all{i},corrCoeff_all{i},numThresholds,0,...
                                    cmapOut,false,timePoints{i});
  [~,~] = plotFitting_singleTimePoint(distances_all,'exp',fitting_stat_all, 'voxel', ...
                              'Separation Distance (um)', 1, ...
                              sprintf('binned numThresholds=%d',numThresholds),...
                              'allDirections', timePoints{i},false)
  str=fullfile('Outs','binning_plot_withExponential',...
              strcat('voxel_binning_withExponential_',timePoints{i},'.jpeg'));
  F=getframe(f);
  imwrite(F.cdata, str, 'jpeg');
end
% str = fullfile('Outs','binning_plot','voxel_binning.jpeg');
% imwrite(F.cdata, str, 'jpeg');
