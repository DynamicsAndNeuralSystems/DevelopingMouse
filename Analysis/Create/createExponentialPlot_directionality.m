clear
load('spatialData_NumData_1000.mat');
load('fitting_NumData_1000_Sagittal.mat');
load('directionalityData.mat')

% exponential fit (3 term) on same plot (voxel data), sagittal
[~,F]= plotFitting(distances_sagittal,'exp',fitting_stat_all,'voxel',...
                    'Separation Distance (um)',0.1,'original','sagittal');
str = fullfile('Outs','exponential_plot_directionality','voxel_directionality_sagittal_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

load('fitting_NumData_1000_Coronal.mat');
% exponential fit (3 term) on same plot (voxel data), coronal
[~,F]= plotFitting(distances_coronal,'exp',fitting_stat_all,'voxel',...
                    'Separation Distance (um)',0.1,'original','coronal');
str = fullfile('Outs','exponential_plot_directionality','voxel_directionality_coronal_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');

load('fitting_NumData_1000_Axial.mat');
% exponential fit (3 term) on same plot (voxel data), axial
[~,F]= plotFitting(distances_axial,'exp',fitting_stat_all,'voxel',...
                    'Separation Distance (um)',0.1,'original','axial');
str = fullfile('Outs','exponential_plot_directionality','voxel_directionality_axial_expFit.jpeg');
imwrite(F.cdata, str, 'jpeg');
%% exponential fit, gene subset (later)
% load('fitting_oligodendrocyteProgenitor.mat');
% [~,F]= plotFitting(spatialData.voxel.distancesAll,'exp',fitting_stat_all,'voxel','Separation Distance (um)',...
%                   0.1,'original');
% str = fullfile('Outs','exponential_plot','voxel_expFit_xScaled.jpeg');
% imwrite(F.cdata, str, 'jpeg');
