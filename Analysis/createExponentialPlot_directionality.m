clear
load('spatialData_NumData_1000.mat');
load('fitting_NumData_1000_Sagittal.mat');

% exponential fit (3 term) on same plot (voxel data)
[~,F]= plotFitting(distances_all,'exp',fitting_stat_all,'voxel',...
                    'Separation Distance (um)',0.1,'original');
str = fullfile('Outs','exponential_plot_directionality','voxel_directionality_sagittal_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

load('fitting_NumData_1000_Coronal.mat');
% exponential fit (3 term) on same plot (voxel data)
[~,F]= plotFitting(distances_all,'exp',fitting_stat_all,'voxel',...
                    'Separation Distance (um)',0.1,'original');
str = fullfile('Outs','exponential_plot_directionality','voxel_directionality_coronal_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

load('fitting_NumData_1000_Axial.mat');
% exponential fit (3 term) on same plot (voxel data)
[~,F]= plotFitting(distances_all,'exp',fitting_stat_all,'voxel',...
                    'Separation Distance (um)',0.1,'original');
str = fullfile('Outs','exponential_plot_directionality','voxel_directionality_axial_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');
%% exponential fit, gene subset (later)
% load('fitting_oligodendrocyteProgenitor.mat');
% [~,F]= plotFitting(spatialData.voxel.distancesAll,'exp',fitting_stat_all,'voxel','Separation Distance (um)',...
%                   0.1,'original');
% str = fullfile('Outs','exponential_plot','voxel_expFit_xScaled.jpeg');
% imwrite(F.cdata, str, 'jpeg');
