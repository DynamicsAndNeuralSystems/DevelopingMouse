%-------------------------------------------------------------------------------
% Create gene coexpression matrix
%-------------------------------------------------------------------------------
%% file directories
% Folder to save the created matlab variables
folder_save=fullfile('Data','Matlab_variables');

%%
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
voxGeneMat_all = cell(length(timePoints));
distMat_all = cell(length(timePoints));
% create annotation grids
makeAnnotationGrids();
% create spinal cord ID
readSpinalCordID()
% create gene coexpression matrix
for i=1:length(timePoints)
    readGridData(timePoints{i})
    [voxGeneMat, distMat] = makeGridData(timePoints{i}, 1000, 'scaledSigmoid');
    voxGeneMat_all{i} = voxGeneMat;
    distMat_all{i} = distMat;
end
%% save variables
str=strcat(folder_save,'\','voxelGeneCoexpression_all','.mat');
save(str,'voxGeneMat_all','distMat_all','-v7.3');