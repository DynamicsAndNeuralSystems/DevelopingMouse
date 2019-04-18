clearvars
%-------------------------------------------------------------------------------
% Create gene coexpression matrix
%-------------------------------------------------------------------------------
%%
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
numData=1000;
whatNorm='scaledSigmoid'; % normalizing method for makeGridData
voxGeneMat_all = cell(length(timePoints),1);
distMat_all = cell(length(timePoints),1);
dataIndSelect_all = cell(length(timePoints),1);
% create annotation grids
makeAnnotationGrids();
% create spinal cord ID
readSpinalCordID()
% create gene expression matrix
for i=1:length(timePoints)
    readGridData(timePoints{i})
    [voxGeneMat, distMat, dataIndSelect] = makeGridData(timePoints{i}, numData, whatNorm, 0.3);
    voxGeneMat_all{i} = voxGeneMat;
    distMat_all{i} = distMat;
    dataIndSelect_all{i} = dataIndSelect;
end
%% save variables
str=fullfile('Matlab_variables', 'voxelGeneCoexpression_all.mat');
save(str,'voxGeneMat_all','distMat_all','dataIndSelect_all','-v7.3');
