clear
load('fitting.mat');
load('binnedData_numThresholds100.mat');
% timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% load('corrCoeffAll_distancesAll.mat','distances_all');
% load('corrCoeff_clean_distances_clean.mat','distances_clean');

%% exponential fit (3 term) on same plot (voxel data)
[~,F]= plotFitting(spatialData.voxel.distancesAll,'exp',fitting_stat_all,'voxel',...
                    'Separation Distance (um)',0.1,'original');
str = fullfile('Outs','exponential_plot','voxel_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

%% exponential fit, old (structureUnionize) and new (voxel)
[~,F] = plotFitting_twoDataTypes(spatialData.voxel.distancesAll,...
                                  spatialData.structure.distancesAll,...
                                  'exp',...
                                  fitting_stat_all, ...
                                  'voxel', ...
                                  'structure')
str = fullfile('Outs','exponential_plot','voxel_structure_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

clear

%% exponential fit, x axis scaled
load('fitting_scaled.mat');
[~,F]= plotFitting(spatialData.voxel.distancesAll_scaled,'exp',fitting_stat_all,'voxel','Separation Distance/maxDistance',...
                  0.1,'original');
str = fullfile('Outs','exponential_plot','voxel_expFit_xScaled.jpeg');
imwrite(F.cdata, str, 'jpeg');
