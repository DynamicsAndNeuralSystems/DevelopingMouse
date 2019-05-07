makeExponentialPlot(1000,20,true,'forebrain',false);
makeExponentialPlot(1000,20,true,'midbrain',false);
makeExponentialPlot(1000,20,true,'hindbrain',false);
% clear
% load('spatialData_NumData_1000.mat');
% load('fitting_NumData_1000.mat');
% % load('binnedData_NumData_1000_numThresholds_100.mat');
% % timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% % load('corrCoeffAll_distancesAll.mat','distances_all');
% % load('corrCoeff_clean_distances_clean.mat','distances_clean');
%
% % exponential fit (3 term) on same plot (voxel data)
% [~,F]= plotFitting(distances_all,'exp',fitting_stat_all,'voxel',...
%                     'Separation Distance (um)',0.1,'original','allDirections');
% str = fullfile('Outs','exponential_plot','voxel_expFit.jpeg');
% imwrite(F.cdata, str, 'jpeg');
%
% clear

%% exponential fit, gene subset (later)
% load('fitting_oligodendrocyteProgenitor.mat');
% [~,F]= plotFitting(spatialData.voxel.distancesAll,'exp',fitting_stat_all,'voxel','Separation Distance (um)',...
%                   0.1,'original');
% str = fullfile('Outs','exponential_plot','voxel_expFit_xScaled.jpeg');
% imwrite(F.cdata, str, 'jpeg');
