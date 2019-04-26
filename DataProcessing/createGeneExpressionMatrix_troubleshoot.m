clearvars
%-------------------------------------------------------------------------------
% Create gene coexpression matrix
%-------------------------------------------------------------------------------
%%
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
numData=1500;
whatNorm='scaledSigmoid'; % normalizing method for makeGridData
voxGeneMat_all = cell(length(timePoints));
distMat_all = cell(length(timePoints));
dataIndSelect_all = cell(length(timePoints));
% create annotation grids
makeAnnotationGrids();
% create spinal cord ID
readSpinalCordID()
% create gene coexpression matrix
for i=1:length(timePoints)
    readGridData_troubleshoot(timePoints{i})
    [voxGeneMat, distMat, dataIndSelect] = makeGridData_troubleshoot_2(timePoints{i}, numData, whatNorm, 0.3, 'all');
    voxGeneMat_all{i} = voxGeneMat;
    distMat_all{i} = distMat;
    dataIndSelect_all{i} = dataIndSelect;
end
%% save variables
% str=fullfile('Data','Matlab_variables', 'voxelGeneCoexpression_all.mat');
% save(str,'voxGeneMat_all','distMat_all','dataIndSelect_all','-v7.3');
