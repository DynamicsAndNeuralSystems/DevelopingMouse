% plot decay constant against max distance
load('fitting_NumData_1000.mat')
[f, F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                                  'original')
% save figure
str=fullfile('Outs', 'decay_constant','decayConstant_voxel.jpeg');
imwrite(F.cdata,str,'jpeg');
