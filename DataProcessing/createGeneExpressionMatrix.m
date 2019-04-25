%-------------------------------------------------------------------------------
% Create gene coexpression matrix
%-------------------------------------------------------------------------------
%%
% load variables
load('annotationGrids.mat');
load('spinalCord_ID.mat');
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
numData=[1500,1500,1500,1500,1500,1500,1500];
% numData='all';
% full size for 7 time points: 210000, 669369, 806520, 115240, 165550, 136000, 158629
% after filtering off spinal cord, unannotated voxels and only including forebrain,midbrain and hindbrain
% the number of voxels are (from voxelGeneCoexpression_all): 5031,9471,11314,11288,19754,21557,24826
numData_brainDiv=[587,1000,1000,1000,1000,1000,1000]; % number of data ...
%for each time point when division of brain is under question...
%(instead of all brain)
whatNorm='scaledSigmoid'; % normalizing method for makeGridData
brainDivisions={'forebrain','midbrain','hindbrain'};
voxelGeneCoexpression_all=struct();
voxelGeneCoexpression_all_brainDiv=struct();

% create gene expression matrix for whole brain
for i=1:length(timePoints)
    load(strcat('energyGrids_',timePoints{i},'.mat'))
    fprintf('hi\n')
    [voxGeneMat, distMat, dataIndSelect] = makeGridData(timePoints{i}, numData(i), whatNorm, 0.3,'all',0);
    voxelGeneCoexpression_all.wholeBrain.voxGeneMat_all{i} = voxGeneMat;
    voxelGeneCoexpression_all.wholeBrain.distMat_all{i} = distMat;
    voxelGeneCoexpression_all.wholeBrain.dataIndSelect_all{i} = dataIndSelect;
    clear energyGrids % saves memory
end
% don't save for now
%% save variables
filename=strcat('voxelGeneCoexpression_all_','voxelNum',num2str(numData(1)),'.mat');
str=fullfile('Matlab_variables', filename);
save(str,'voxelGeneCoexpression_all','-v7.3');

% clear variable to save memory
clear voxelGeneCoexpression_all

% Ignore brain divisions for now
% %% create gene expression matrix for each brain divisions
% for k=1:length(brainDivisions)
%     for i=1:length(timePoints)
%         [voxGeneMat, distMat, dataIndSelect] = makeGridData(timePoints{i}, numData_brainDiv(i), ...
%                                                             whatNorm, 0.3, brainDivisions{k},0);
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).voxGeneMat_all{i} = voxGeneMat;
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).distMat_all{i} = distMat;
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).dataIndSelect_all{i} = dataIndSelect;
%     end
% end
%
% % save variables
% str=fullfile('Matlab_variables', 'voxelGeneCoexpression_all_brainDiv.mat');
% save(str,'voxelGeneCoexpression_all_brainDiv','-v7.3');
