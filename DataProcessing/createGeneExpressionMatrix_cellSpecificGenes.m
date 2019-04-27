%-------------------------------------------------------------------------------
% Create gene coexpression matrix
%-------------------------------------------------------------------------------
%%
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
numData=1000;
numData_brainDiv=[587,1000,1000,1000,1000,1000,1000]; % number of data ...
%for each time point when division of brain is under question...
%(instead of all brain)
whatNorm='scaledSigmoid'; % normalizing method for makeGridData
% brainDivisions={'forebrain','midbrain','hindbrain'};
voxelGeneCoexpression_all_subsetGenes=struct();
% ignore brain divisions for now
% voxelGeneCoexpression_all_brainDiv_cellSpecificGenes=struct();

% get the required gene ID
load('enrichedGenes.mat'); % contains 'enrichedGenes','geneAbbreviation','geneID'
abbreviation_subsetGenes=enrichedGenes.astrocyte.developing;
% map the gene abbreviation to the gene ID
geneIDix=zeros(length(abbreviation_subsetGenes),1);
for j=1:length(abbreviation_subsetGenes)
  % for each gene in the gene subset
    geneIDix(j)=find(cellfun(@(x) strcmp(enrichedGenes.astrocyte.developing{j},x),geneAbbreviation));
end
geneID_subsetGenes=geneID(geneIDix);
% create gene expression matrix for whole brain
for i=1:length(timePoints)
    readGridData(timePoints{i});
    [voxGeneMat, distMat, dataIndSelect] = makeGridData_subsetGenes(timePoints{i}, ...
                                                                    numData, ...
                                                                    whatNorm, ...
                                                                    0.3,...
                                                                    'all',...
                                                                    geneID_subsetGenes);
    voxelGeneCoexpression_all.wholeBrain.voxGeneMat_all{i} = voxGeneMat;
    voxelGeneCoexpression_all.wholeBrain.distMat_all{i} = distMat;
    voxelGeneCoexpression_all.wholeBrain.dataIndSelect_all{i} = dataIndSelect;
end

%% save variables
str=fullfile('Matlab_variables', 'voxelGeneCoexpression_all_subsetGenes.mat');
save(str,'voxelGeneCoexpression_all_subsetGenes','-v7.3');

% clear variable to save memory
clear voxelGeneCoexpression_all

% ignore brain divisions for now
% %% create gene expression matrix for each brain divisions
% for k=1:length(brainDivisions)
%     for i=1:length(timePoints)
%         [voxGeneMat, distMat, dataIndSelect] = makeGridData(timePoints{i}, numData_brainDiv(i), whatNorm, 0.3, brainDivisions{k});
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).voxGeneMat_all{i} = voxGeneMat;
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).distMat_all{i} = distMat;
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).dataIndSelect_all{i} = dataIndSelect;
%     end
% end
%
% % save variables
% str=fullfile('Matlab_variables', 'voxelGeneCoexpression_all_brainDiv.mat');
% save(str,'voxelGeneCoexpression_all_brainDiv','-v7.3');
