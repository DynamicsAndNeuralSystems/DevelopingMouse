% plot decay constant against max distance
load('fitting_NumData_1000_binnedData_numThresholds_100.mat')
[f, F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                                  'binned numThresholds=100')
% save figure
str=fullfile('Outs', 'decay_constant',strcat('decayConstant_binned.jpeg'));
imwrite(F.cdata,str,'jpeg');
