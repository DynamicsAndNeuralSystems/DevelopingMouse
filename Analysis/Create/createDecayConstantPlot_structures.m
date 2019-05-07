% plot decay constant against max distance
load('fitting_structures.mat')
[f, F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                                  'original')
% save figure
str=fullfile('Outs', 'decay_constant',strcat('decayConstant_structure.jpeg'));
imwrite(F.cdata,str,'jpeg');
