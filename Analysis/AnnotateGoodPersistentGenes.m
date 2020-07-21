function AnnotateGoodPersistentGenes(params)
% Annotate genes by their goodness at an individual time point and across time points
% (computed across all genes and all brain-annotated voxels)
%-------------------------------------------------------------------------------

if nargin < 1
    params = GiveMeDefaultParams();
end
params.thisCellType = 'allCellTypes';
params.thisBrainDiv = 'brain';

timePoints = GiveMeParameter('timePoints');
numTimePoints = length(timePoints);

%-------------------------------------------------------------------------------
% First label 'good' genes at each time point
goodGeneID = cell(numTimePoints,1);

for i = 1:numTimePoints
    % Compute good brain genes and save this info back:
    [voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePoints{i});
    isGoodGeneBrain = (mean(isnan(voxelGeneExpression),1) < params.whatGeneThreshold)';
    geneInfo.isGoodGeneBrain = isGoodGeneBrain;
    fileName = GiveMeFileName(timePoints{i});
    save(fileName,'geneInfo','-append');
    fprintf(1,'Saved ''good gene'' info back to %s\n',fileName);

    % Keep good entrez IDs of good genes:
    goodGeneID{i} = geneInfo.entrezID(isGoodGeneBrain);
end

%-------------------------------------------------------------------------------
% Full screen figure:
% f = figure('color','w','Position',get(0,'Screensize'));
% imagesc(geneMatrix)
% colormap([0 0 0; 1 1 1])
% xLabel = GiveMeLabelName('genes');
% yLabel = GiveMeLabelName('timePoints');
% xlabel(xLabel)
% ylabel(yLabel)
% ax = gca;
% ax.YTickLabel = timePoints;
% % set(gca,'xtick',[1:length(SDKgeneEntrez)],'xticklabel',geneAbbreviation)
% title('Gene status across time points', 'FontSize', 14)
% str=fullfile('Outs','voxGeneMatStats_geneAcrossTime','voxGeneMatStats_geneAcrossTime.jpeg');
% saveas(f,str)
%-------------------------------------------------------------------------------

% get subset of genes that are good across time points
allEntrez = unique(vertcat(goodGeneID{:}));
propGood = arrayfun(@(x)mean(cellfun(@(y)ismember(x,y),goodGeneID)),allEntrez);
alwaysGoodIDs = allEntrez(propGood==1);

% Go through and label these 'alwaysGoodIDs'
for i = 1:numTimePoints
    fileName = GiveMeFileName(timePoints{i});
    load(fileName,'geneInfo');
    isPersistent = ismember(geneInfo.entrezID,alwaysGoodIDs);
    geneInfo.isPersistent = isPersistent;
    save(fileName,'geneInfo','-append');
    fprintf(1,'Saved ''isPersistent'' info back to %s\n',fileName);
end

end
