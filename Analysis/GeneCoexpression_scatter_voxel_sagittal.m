%---------------------------------------------------------------------
% initialize and load variables
%---------------------------------------------------------------------
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('spatialData_NumData_1000.mat') % contains 'voxGeneMat_all','distMat_all','dataIndSelect_all'
load('fitting_NumData_1000_Sagittal.mat');
%
%---------------------------------------------------------------------
% Plot gene coexpression against distance
%---------------------------------------------------------------------
% create variables and plot
for i = 1:length(timePoints)
    [f,F]=plotGeneCoexpression_scatter_voxel(...
                                            corrCoeff_all{i},...
                                            distances_all{i},...
                                            fitting_stat_all,...
                                            timePoints{i},...
                                            'wholeBrain',....
                                            1); % plot density too
    filename=strcat('scatter_voxel_sagittal','_',timePoints{i},'.jpeg');
    str=fullfile('Outs','scatter_voxel_sagittal',filename);
    imwrite(F.cdata,str,'jpeg');
end
