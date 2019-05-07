function makeBrainDivision()
% initialize

brainDivision=struct();
% divisions={'forebrain','midbrain','hindbrain'};

% import forebrain IDs
brainDivision.forebrain.ID=csvread('structure_F_descendant_ID.csv',1,1,[1 1 1130 1]);
% import midbrain IDs
brainDivision.midbrain.ID=csvread('structure_M_descendant_ID.csv',1,1,[1 1 176 1]);
% import hindbrain IDs
brainDivision.hindbrain.ID=csvread('structure_H_descendant_ID.csv',1,1,[1 1 1089 1]);

% import forebrain colour
brainDivision.forebrain.color=importfile_structure('structure_F.csv');
% import midbrain colour
brainDivision.midbrain.color=importfile_structure('structure_M.csv');
% import hindbrain colour
brainDivision.hindbrain.color=importfile_structure('structure_H.csv');

str=fullfile('Matlab_variables','brainDivision.mat');
save(str,'brainDivision')

end
