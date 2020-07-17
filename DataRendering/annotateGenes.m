function annotateGenes(timePointNow)

%-------------------------------------------------------------------------------
% Load gene IDs for this time point
fileName = GiveMeFileName(timePointNow);
load(fileName,'geneIDs')

%-------------------------------------------------------------------------------
% Load IDs of genes enriched in astrocytees, oligodendrocytes, neurons:

[~,astrocyte] = xlsread('Astrocyte_Cahoy_S4.xls');
astrocyte = astrocyte(3:end,3); % filter gene names
[~,oligodendrocyte] = xlsread('Oligodendrocyte_Cahoy_S5.xls');
oligodendrocyte = oligodendrocyte(3:end,3); % filter gene names
[~,neuron] = xlsread('Neuron_Cahoy_S6.xls');
neuron = neuron(3:end,3); % filter gene names

%-------------------------------------------------------------------------------



% filterBad = @() x(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),astrocyte)) = {''};

% enrichedGenes = struct();
% imports genes names enriched >10 fold in astrocytes
% astrocyte=astrocyte_importfile('Astrocyte_Cahoy_S4.xls','Sheet1','C3:C184');
% imports genes names enriched >10 fold in oligodendrocytes
% oligodendrocyte=oligodendrocyte_importfile('Oligodendrocyte_Cahoy_S5.xls','Sheet1','C3:C130');
% imports genes names enriched >10 fold in neurons
% neuron=neuron_importfile('Neuron_Cahoy_S6.xls','Sheet1','C3:C318');

end
