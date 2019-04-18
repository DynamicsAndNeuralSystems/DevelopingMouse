clearvars
%---------------------------------------------------------------------
% initialize and load variables
%---------------------------------------------------------------------
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('voxelGeneCoexpression_all') % contains 'voxGeneMat_all','distMat_all','dataIndSelect_all'
%%
%---------------------------------------------------------------------
% Plot gene coexpression against distance
%---------------------------------------------------------------------
% initialize
distances_all = cell(length(timePoints),1);
corrCoeff_all = cell(length(timePoints),1);
% create variables and plot
for i = 1:length(timePoints)
    % extract the correlation coefficients
    geneCorr=corrcoef((voxGeneMat_all{i}(dataIndSelect_all{i},:))','rows','pairwise');
    corrCoeff_all{i}=geneCorr(find(triu(ones(size(geneCorr)),1)));
    % extract distances from distance matrix
    distances_all{i} = extractDistances(distMat_all{i});
    % plot coexpression against distance
    f=figure('color','w');
    gcf;
    scatter(distances_all{i},corrCoeff_all{i},'.')
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    str = sprintf('Developing Mouse %s',timePoints{i});
    title(str,'Fontsize',19);
    f=figureFullScreen(f,true);
    % save the figure
    filename=strcat('scatter_voxel','_',timePoints{i},'.jpeg');
    str=fullfile('Outs','scatter_voxel',filename);
    saveas(f,str)
end
%---------------------------------------------------------------------
% save variables
%---------------------------------------------------------------------
str=fullfile('Matlab_variables','corrCoeffAll_distanceAll.mat');
save(str, 'distances_all', 'corrCoeff_all');
