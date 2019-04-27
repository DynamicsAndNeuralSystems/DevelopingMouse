function makeCorrCoeffAll_distancesAll(MatrixName, brainDivision)
  % MatrixName: a string of the name of the matlab variable and the struct it contains, which has
  % fields 'brainDivision', which has subfields 'voxGeneMat_all','distMat_all','dataIndSelect_all'
  % brainDivision: either 'wholeBrain', 'forebrain','midbrain' or 'hindbrain'
%---------------------------------------------------------------------
% initialize and load variables
%---------------------------------------------------------------------
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load(strcat(MatrixName,'.mat')) % contains 'voxGeneMat_all','distMat_all','dataIndSelect_all'

% initialize
distances_all = cell(length(timePoints),1);
corrCoeff_all = cell(length(timePoints),1);
distances_all_scaled = cell(length(timePoints),1);
%---------------------------------------------------------------------
% Plot gene coexpression against distance
%---------------------------------------------------------------------
% create variables and plot
for i = 1:length(timePoints)
    [distances_all{i},corrCoeff_all{i}]=computeCorrCoeff_distances(...
                                        (Matrixname).(brainDivision).voxGeneMat_all{i},...
                                        (Matrixname).(brainDivision).distMat_all{i},...
                                        (Matrixname).(brainDivision).dataIndSelect_all{i});
    % create another distance cell normalized by max distance
    distances_all_scaled{i}=distances_all{i}/max(distances_all{i});
    % saveas(f,str)
end
%%
%---------------------------------------------------------------------
% save variables
%---------------------------------------------------------------------
str=fullfile('Matlab_variables',strcat('corrCoeffAll_distancesAll_',MatrixName,'.mat'));
save(str, 'distances_all', 'corrCoeff_all', 'distances_all_scaled');
