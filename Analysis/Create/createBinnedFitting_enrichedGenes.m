function createBinnedFitting(doScaled)

if nargin < 1
    doScaled = true;
end
makeBinnedFitting_enrichedGenes(1000,20,'wholeBrain','neuron',doScaled);
makeBinnedFitting_enrichedGenes(1000,20,'wholeBrain','oligodendrocyte',doScaled);
makeBinnedFitting_enrichedGenes(1000,20,'wholeBrain','astrocyte',doScaled);

end
