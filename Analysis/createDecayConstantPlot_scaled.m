% plot decay constant against max distance
load('fitting_NumData_1000_scaled.mat')
[f, F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                                  'original, scaled distance')
% save figure
str=fullfile('Outs', 'decay_constant','decayConstant_voxel_scaled.jpeg');
imwrite(F.cdata,str,'jpeg');
