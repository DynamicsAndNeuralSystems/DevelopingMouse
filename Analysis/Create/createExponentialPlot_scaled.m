clear
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('spatialData_NumData_1000.mat');
load('fitting_NumData_1000_scaled.mat');
% first scale the distances
distances_all_scaled=cell(length(timePoints),1);
for i=1:length(timePoints)
  distances_all_scaled{i}=distances_all{i}/max(distances_all{i});
end
%% exponential fit, x axis scaled (distance/max distance)
[~,F]= plotFitting(distances_all_scaled,'exp',fitting_stat_all,'voxel','Separation Distance/maxDistance)',...
                  0.1,'original');
str = fullfile('Outs','exponential_plot','voxel_expFit_xScaled.jpeg');
% imwrite(F.cdata, str, 'jpeg');
