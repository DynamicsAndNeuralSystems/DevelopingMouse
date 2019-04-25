%---------------------------------------------------------------------
% initialize and load variables
%---------------------------------------------------------------------
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('voxelGeneCoexpression_all.mat') % contains 'voxGeneMat_all','distMat_all','dataIndSelect_all'
load('fitting.mat');
%
% initialize
distances_all = cell(length(timePoints),1);
corrCoeff_all = cell(length(timePoints),1);
distances_all_scaled = cell(length(timePoints),1);
%---------------------------------------------------------------------
% Plot gene coexpression against distance
%---------------------------------------------------------------------
% create variables and plot
for i = 1:length(timePoints)
    [f,F,distances_all{i},corrCoeff_all{i}]=plotGeneCoexpression_scatter_voxel(...
                                            voxelGeneCoexpression_all.wholeBrain.voxGeneMat_all{i},...
                                            voxelGeneCoexpression_all.wholeBrain.dataIndSelect_all{i},...
                                            voxelGeneCoexpression_all.wholeBrain.distMat_all{i},...
                                            fitting_stat_all,...
                                            timePoints{i},...
                                            'wholeBrain',....
                                            1); % plot density too
    filename=strcat('scatter_voxel','_',timePoints{i},'.jpeg');
    str=fullfile('Outs','scatter_voxel',filename);
    imwrite(F.cdata,str,'jpeg');
    % create another distance cell normalized by max distance
    distances_all_scaled{i}=distances_all{i}/(max(distances_all{i})*max(distances_all{i}));
    % saveas(f,str)
end
%%
%---------------------------------------------------------------------
% save variables
%---------------------------------------------------------------------
str=fullfile('Matlab_variables','corrCoeffAll_distancesAll.mat');
save(str, 'distances_all', 'corrCoeff_all', 'distances_all_scaled');
