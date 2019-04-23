% initialize
enrichedGenes=struct();
% imports genes names enriched >10 fold in developing cf mature astrocytes
enrichedGenes.astrocyte.developing=importfile_DevAstrocyte_enriched('Developing_astrocyte_enriched_Cahoy_S15.xls');
% imports genes names enriched >10 fold in mature cf developing astrocytes
enrichedGenes.astrocyte.mature=importfile_MatureAstrocyte_enriched('Mature_astrocyte_enriched_Cahoy_S16.xls');
% imports genes names enriched >10 fold in progenitor cf postmitotic oligodendrocytes
enrichedGenes.oligodendrocyte.progenitor=importfile_ProgenitorOligodendrocyte_enriched('Progenitor_oligodendrocyte_enriched_Cahoy_S17.xls');
% imports genes names enriched >10 fold in postmitotic cf progenitor oligodendrocytes
enrichedGenes.oligodendrocyte.postmitotic=importfile_PostmitoticOligodendrocyte_enriched('Postmitotic_oligodendrocyte_enriched_Cahoy_S18.xls');
%%
% load gene names in Allen Developing Mouse
load('DevMouseGeneExpression.mat','geneList');
%%
% Only keep enriched genes that are present in the Allen data
isInAllen=ismember(enrichedGenes.astrocyte.developing,geneList);
enrichedGenes.astrocyte.developing=enrichedGenes.astrocyte.developing(isInAllen);
%%
isInAllen=ismember(enrichedGenes.astrocyte.mature,geneList);
enrichedGenes.astrocyte.mature=enrichedGenes.astrocyte.mature(isInAllen);

%%
isInAllen=ismember(enrichedGenes.oligodendrocyte.progenitor,geneList);
enrichedGenes.oligodendrocyte.progenitor=enrichedGenes.oligodendrocyte.progenitor(isInAllen);
%%
isInAllen=ismember(enrichedGenes.oligodendrocyte.postmitotic,geneList);
enrichedGenes.oligodendrocyte.postmitotic=enrichedGenes.oligodendrocyte.postmitotic(isInAllen);

% match gene name abbreviation to gene ID
geneAbbreviation=importfile_SDK_geneAbbreviations('SDK_geneAbbreviations.csv');
geneID=importfile_SDK_geneEntrez('SDK_geneEntrez.csv');

% save variable
str=fullfile('Matlab_variables','enrichedGenes.mat');
save(str,'enrichedGenes','geneAbbreviation','geneID');
