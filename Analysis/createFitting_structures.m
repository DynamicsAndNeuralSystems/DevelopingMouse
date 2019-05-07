timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
filestr='corrCoeff_distances_ontoDist_clean';
load(strcat(filestr,'.mat'));
% create fitting
[fitting_stat_all, decayConstant, maxDistance]=getFitting(distances_clean,corrCoeff_clean);
str=fullfile('Matlab_variables','fitting_structures.mat');
save(str,'fitting_stat_all','decayConstant','maxDistance');
