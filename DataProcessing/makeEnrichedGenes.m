function makeEnrichedGenes()
% initialize
enrichedGenes=struct();
% imports genes names enriched >10 fold in astrocytes
% astrocyte=astrocyte_importfile('Astrocyte_Cahoy_S4.xls','Sheet1','C3:C184');
astrocyte=readcell('Astrocyte_Cahoy_S4.xls','Sheet','Sheet1','range','C3:C184');
astrocyte(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),astrocyte)) = {''};

% imports genes names enriched >10 fold in oligodendrocytes
% oligodendrocyte=oligodendrocyte_importfile('Oligodendrocyte_Cahoy_S5.xls','Sheet1','C3:C130');
oligodendrocyte=readcell('Oligodendrocyte_Cahoy_S5.xls','Sheet','Sheet1','range','C3:C130');
oligodendrocyte(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),oligodendrocyte)) = {''};

% imports genes names enriched >10 fold in neurons
% neuron=neuron_importfile('Neuron_Cahoy_S6.xls','Sheet1','C3:C318');
neuron=readcell('Neuron_Cahoy_S6.xls','Sheet','Sheet1','range','C3:C318');
neuron(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),neuron)) = {''};
%%
% load IDs of good gene subset
load('goodGeneSubset.mat','goodGeneSubset');
% get the acronyms of good gene subset
load('DevMouseGeneExpression.mat','geneList','geneEntrez');
% match ids to acronyms in goodGeneSubset
goodGeneSubset=cell2mat(goodGeneSubset); % turn goodGeneSubset into a vector
[~,ix,~]=intersect(geneEntrez,goodGeneSubset,'stable');
%%
goodGeneSubset_acronym=geneList(ix);
% Only keep enriched genes that are present in the good gene data
[~,~,ib]=intersect(astrocyte,goodGeneSubset_acronym,'stable');
enrichedGenes.astrocyte.acronym=goodGeneSubset_acronym(ib);
enrichedGenes.astrocyte.ID=goodGeneSubset(ib);
%%
[~,~,ib]=intersect(oligodendrocyte,goodGeneSubset_acronym,'stable');
enrichedGenes.oligodendrocyte.acronym=goodGeneSubset_acronym(ib);
enrichedGenes.oligodendrocyte.ID=goodGeneSubset(ib);

%%
[~,~,ib]=intersect(neuron,goodGeneSubset_acronym,'stable');
enrichedGenes.neuron.acronym=goodGeneSubset_acronym(ib);
enrichedGenes.neuron.ID=goodGeneSubset(ib);

% save variable
str=fullfile('Matlab_variables','enrichedGenes.mat');
save(str,'enrichedGenes');
save('goodGeneSubset.mat','goodGeneSubset_acronym','-append');
end
