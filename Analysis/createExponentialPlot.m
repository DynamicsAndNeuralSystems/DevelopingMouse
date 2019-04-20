clear
load('fitting.mat');
% load('corrCoeffAll_distancesAll.mat','distances_all');
% load('corrCoeff_clean_distances_clean.mat','distances_clean');

%% exponential fit (3 term) on same plot (voxel data)
[~,F]= plotFitting(spatialData.voxel.distancesAll,'exp',fitting_stat_all,'voxel');
str = fullfile('Outs','exponential_plot','voxel_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

%% exponential fit, old (structureUnionize) and new (voxel)
[~,F] = plotFitting_twoDataTypes(spatialData.voxel.distancesAll,spatialData.structure.distancesAll,'exp',fitting_stat_all, 'voxel', 'structure')
str = fullfile('Outs','exponential_plot','voxel_structure_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');
