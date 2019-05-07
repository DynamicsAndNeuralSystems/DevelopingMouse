% get the required gene ID
load('enrichedGenes.mat'); % contains 'enrichedGenes','geneAbbreviation','geneID'
abbreviation_subsetGenes=enrichedGenes.oligodendrocyte.progenitor;
% map the gene abbreviation to the gene ID
geneIDix=zeros(length(abbreviation_subsetGenes),1);
for j=1:length(abbreviation_subsetGenes)
  % for each gene in the gene subset
    geneIDix(j)=find(cellfun(@(x) strcmp(abbreviation_subsetGenes{j},x),geneAbbreviation));
end
%
geneID_subsetGenes=geneID(geneIDix);

% save
str=fullfile('Matlab_variables','geneID_subsetGenes.mat');
save(str,'geneID_subsetGenes')
