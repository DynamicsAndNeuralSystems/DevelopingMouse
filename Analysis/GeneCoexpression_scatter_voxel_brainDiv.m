%---------------------------------------------------------------------
% initialize and load variables
%---------------------------------------------------------------------
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('voxelGeneCoexpression_all_brainDiv') % contains 'voxGeneMat_all','distMat_all','dataIndSelect_all'
brainDivisions={'forebrain','midbrain','hindbrain'};
corrCoeffAll_distancesAll_brainDiv=struct();
%---------------------------------------------------------------------
% Plot gene coexpression against distance
%---------------------------------------------------------------------
% create variables and plot
for k = 1:length(brainDivisions)
  % initialize
  corrCoeffAll_distancesAll_brainDiv.(brainDivisions{k}).distances_all = cell(length(timePoints),1);
  corrCoeffAll_distancesAll_brainDiv.(brainDivisions{k}).corrCoeff_all = cell(length(timePoints),1);
  for i = 1:length(timePoints)
      [f,F,corrCoeffAll_distancesAll_brainDiv.(brainDivisions{k}).distances_all{i},...
        corrCoeffAll_distancesAll_brainDiv.(brainDivisions{k}).corrCoeff_all{i}]=...
                                              plotGeneCoexpression_scatter_voxel(...
                                              voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).voxGeneMat_all{i},...
                                              voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).dataIndSelect_all{i},...
                                              voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).distMat_all{i},...
                                              timePoints{i},...
                                              brainDivisions{k});
      str = sprintf('Developing Mouse %s %s',timePoints{i},brainDivisions{k});
      filename=strcat('scatter_voxel','_',brainDivisions{k},'_',timePoints{i},'.jpeg');
      str=fullfile('Outs','scatter_voxel_brainDiv',filename);
      imwrite(F.cdata,str,'jpeg');
      % saveas(f,str)
  end
end
%%
%---------------------------------------------------------------------
% save variables
%---------------------------------------------------------------------
str=fullfile('Matlab_variables','corrCoeffAll_distancesAll_brainDiv.mat');
save(str, 'corrCoeffAll_distancesAll_brainDiv');
