clear
load('fitting_binned.mat');
load('binnedData_numThresholds100');
% timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% load('corrCoeffAll_distancesAll.mat','distances_all');
% load('corrCoeff_clean_distances_clean.mat','distances_clean');
%%
%% exponential fit (3 term) on same plot (binned voxel data)
[~,F]= plotFitting(xPlotDataAll,'exp',fitting_stat_all,'voxel','Separation Distance (um)',1,sprintf('binned numThresholds=%d',numThresholds));
str = fullfile('Outs','exponential_plot_binned','voxel_binned_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

clear decayConstant fitting_stat_all maxDistance spatialData

load('fitting_binned_scaled.mat');
%% exponential fit (3 term) on same plot (binned voxel data with distance scaled)
[~,F]= plotFitting(xPlotDataAll_scaled,'exp',fitting_stat_all,'voxel','Separation Distance/maxDistance',1,sprintf('binned numThresholds=%d',numThresholds));
str = fullfile('Outs','exponential_plot_binned_scaled','voxel_binned_scaled_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');
