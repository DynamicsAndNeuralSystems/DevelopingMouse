load('voxelGeneCoexpression_all.mat');
fitting_stat_all = cell(7,1);
for i = 1:length(timePoints)
    % extract the correlation coefficients
    geneCorr=corrcoef((voxGeneMat_all{i}(dataIndSelect_all{i},:))','rows','pairwise');
    corrCoeff=geneCorr(find(triu(ones(size(geneCorr)),1)));
    % extract distances from distance matrix
    distances = extractDistances(distMat_all{i});
    fitting_stat_all{i}=fitting_stat({'linear','exp_1_0','exp1','exp'}, '', distances, corrCoeff);
end
