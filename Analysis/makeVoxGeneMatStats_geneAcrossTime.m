function makeVoxGeneMatStats_geneAcrossTime()

timePoints = GiveMeParameter('timePoints');
numTimePoints = length(timePoints);
load('geneID_gridExpression.mat','geneID_gridExpression');

% collect the set of genes that are present in any time points
SDKgeneEntrez = importfile_SDK_geneEntrez('SDK_geneEntrez.csv');
numGenes = length(SDKgeneEntrez);

% [~,geneAbbreviation,~]=xlsread('SDK_geneAbbreviations.csv','A1:CBX1');
% initialize
isGoodGene_all = cell(numTimePoints,1);
geneIDInfo_all = cell(numTimePoints,1);
isGoodGene_all_index = cell(numTimePoints,1);
geneMatrix = zeros(numTimePoints,numGenes);

%-------------------------------------------------------------------------------
% collect data on which genes are good in each time point
for i = 1:numTimePoints
    % collect good gene index
    load(strcat('voxelGeneCoexpression_',timePoints{i},'.mat'));
    isGoodGene_all{i} = isGoodGene;
    % find out the good genes in each time point as an index of SDKgeneEntrez
    isGoodGene_all_index{i} = ismember(...
                    cellfun(@(x) num2str(x), SDKgeneEntrez,'UniformOutput',false),...
                    cellfun(@(x) num2str(x), ...
                    geneID_gridExpression.(timePoints{i})(isGoodGene_all{i}),...
                            'UniformOutput',false));
    % create a matrix of on-off genes
    geneMatrix(i,:)=isGoodGene_all_index{i};
end

%-------------------------------------------------------------------------------
% Full screen figure:
f = figure('color','w','Position',get(0,'Screensize'));
imagesc(geneMatrix)
colormap([0 0 0; 1 1 1])
xLabel = GiveMeLabelName('genes');
yLabel = GiveMeLabelName('timePoints');
xlabel(xLabel)
ylabel(yLabel)
ax = gca;
ax.YTickLabel = timePoints;
% set(gca,'xtick',[1:length(SDKgeneEntrez)],'xticklabel',geneAbbreviation)
title('Gene status across time points', 'FontSize', 14)
str=fullfile('Outs','voxGeneMatStats_geneAcrossTime','voxGeneMatStats_geneAcrossTime.jpeg');
saveas(f,str)

% get subset of genes that are good across time points
goodGeneSubset = SDKgeneEntrez(arrayfun(@(x) x==7, sum(geneMatrix)));
str = fullfile('Matlab_variables','goodGeneSubset.mat');
save(str,'goodGeneSubset','isGoodGene_all','isGoodGene_all_index');

end
