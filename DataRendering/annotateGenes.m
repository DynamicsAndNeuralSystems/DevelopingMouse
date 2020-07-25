function annotateGenes(timePointNow)
% Adds a geneInfo table to the matlab voxel expression data file for a given time point
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Load gene IDs for this time point
fileName = GiveMeFileName(timePointNow);
load(fileName,'geneIDs')
numGenes = length(geneIDs);

%-------------------------------------------------------------------------------
% Map genes to entrez
if strcmp(timePointNow,'P56')
  geneEntrezAll = dlmread('Adult_geneEntrez.csv');
  fid = fopen('Adult_geneAbbreviation.csv','r');
else
  geneEntrezAll = dlmread('Dev_geneEntrez.csv')';
  fid = fopen('Dev_geneAbbreviation.csv','r');
end
geneAbbreviationsAll = textscan(fid,'%s','Delimiter',',','CollectOutput',true);
fclose(fid);
geneAbbreviationsAll = geneAbbreviationsAll{1};

acronym = cell(numGenes,1);
for i = 1:numGenes
    matchHere = find(geneEntrezAll==geneIDs(i));
    acronym{i} = geneAbbreviationsAll{matchHere};
end

%-------------------------------------------------------------------------------
% Load IDs of genes enriched in astrocytes, oligodendrocytes, neurons:
[~,astrocyte] = xlsread('Astrocyte_Cahoy_S4.xls');
astrocyte = astrocyte(3:end,3); % filter gene names
[~,oligodendrocyte] = xlsread('Oligodendrocyte_Cahoy_S5.xls');
oligodendrocyte = oligodendrocyte(3:end,3); % filter gene names
[~,neuron] = xlsread('Neuron_Cahoy_S6.xls');
neuron = neuron(3:end,3); % filter gene names

isAstrocyteEnriched = ismember(acronym,astrocyte);
isOligodendrocyteEnriched = ismember(acronym,oligodendrocyte);
isNeuronEnriched = ismember(acronym,neuron);

entrezID = geneIDs;
geneInfo = table(entrezID,acronym,isAstrocyteEnriched,isOligodendrocyteEnriched,...
                isNeuronEnriched);

save(fileName,'geneInfo','-append');


% filterBad = @() x(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),astrocyte)) = {''};

% enrichedGenes = struct();
% imports genes names enriched >10 fold in astrocytes
% astrocyte=astrocyte_importfile('Astrocyte_Cahoy_S4.xls','Sheet1','C3:C184');
% imports genes names enriched >10 fold in oligodendrocytes
% oligodendrocyte=oligodendrocyte_importfile('Oligodendrocyte_Cahoy_S5.xls','Sheet1','C3:C130');
% imports genes names enriched >10 fold in neurons
% neuron=neuron_importfile('Neuron_Cahoy_S6.xls','Sheet1','C3:C318');

end
