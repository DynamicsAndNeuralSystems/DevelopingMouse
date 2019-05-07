% plot decay constant against max distance
load('fitting_NumData_1000_binnedData_numThresholds_100_scaled.mat')
[f, F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                                  'binned numThresholds=100, scaled distance')
% save figure
str=fullfile('Outs', 'decay_constant',strcat('decayConstant_binned_scaled.jpeg'));
imwrite(F.cdata,str,'jpeg');
