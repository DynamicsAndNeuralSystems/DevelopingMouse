% plot decay constant against max distance
load('fitting_NumData_1000_Coronal.mat')
coronal_stat=fitting_stat_all;
coronal_decayConstant=decayConstant;
coronal_maxDistance=maxDistance;
load('fitting_NumData_1000_Axial.mat')
axial_stat=fitting_stat_all;
axial_decayConstant=decayConstant;
axial_maxDistance=maxDistance;
load('fitting_NumData_1000_Sagittal.mat')
sagittal_stat=fitting_stat_all;
sagittal_decayConstant=decayConstant;
sagittal_maxDistance=maxDistance;
plotDecayConstant_directionality(coronal_stat,axial_stat,sagittal_stat,...
                                coronal_decayConstant,axial_decayConstant,sagittal_decayConstant,...
                                coronal_maxDistance,axial_maxDistance,sagittal_maxDistance,...
                                {'coronal','axial','sagittal'},...
                                'voxel','wholeBrain','original');
