clear
load('fitting_NumData_1000_binnedData_numThresholds_20.mat');
filestr='binnedData_NumData_1000_numThresholds_20';
load(strcat(filestr,'.mat'));
file_parts=strsplit(filestr,'_');
% NumData=file_parts{3};
numThresholds=file_parts{5};
%%
%% exponential fit (3 term) on same plot (binned voxel data)
[~,F]= plotFitting(xPlotDataAll,'exp',fitting_stat_all,'voxel',...
                  'Separation Distance (um)',1,...
                  sprintf('binned numThresholds=%s',numThresholds),'allDirections');
str = fullfile('Outs','exponential_plot_binned','voxel_binned_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

load('fitting_NumData_1000_binnedData_numThresholds_20_scaled.mat');
%% exponential fit (3 term) on same plot (binned voxel data with distance scaled)
[~,F]= plotFitting(xPlotDataAll_scaled,'exp',fitting_stat_all,'voxel',...
                  'Separation Distance/maxDistance',1,...
                  sprintf('binned numThresholds=%s',numThresholds),'allDirections');
str = fullfile('Outs','exponential_plot_binned_scaled','voxel_binned_scaled_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');
