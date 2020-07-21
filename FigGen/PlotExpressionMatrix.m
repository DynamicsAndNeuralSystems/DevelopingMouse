function PlotExpressionMatrix(timePointNow,params,whatPlot)
% Plot voxelwise gene-expression matrix from file (processed according to parameters
% specified in params)
%-------------------------------------------------------------------------------
if nargin < 1
    timePointNow = 'E11pt5';
end
if nargin < 2
    params = GiveMeDefaultParams();
end
if nargin < 3
    whatPlot = 'subDivision';
end

%-------------------------------------------------------------------------------
% All voxel plot
%-------------------------------------------------------------------------------
switch whatPlot
case 'allVoxel'
    params.thisBrainDiv = 'all';
    [voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);

    ord_row = BF_ClusterReorder(voxelGeneExpression,'corr_fast','average');
    ord_col = BF_ClusterReorder(voxelGeneExpression','corr_fast','average');

    f = figure('color','w');
    subplot(1,10,1)
    imagesc(voxInfo.isBrain(ord_row))
    subplot(1,10,2:10)
    imagesc(voxelGeneExpression(ord_row,ord_col))
    colormap(flipud(BF_getcmap('redyellowblue',11,0)))
    title(timePointNow)

case 'allVoxelOrder'
    params.thisBrainDiv = 'all';
    [voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);
    voxelGeneExpressionBrain = voxelGeneExpression(voxInfo.isBrain,:);
    voxelGeneExpressionNotBrain = voxelGeneExpression(~voxInfo.isBrain,:);

    ord_row_brain = BF_ClusterReorder(voxelGeneExpressionBrain,'corr_fast','average');
    ord_row_notBrain = BF_ClusterReorder(voxelGeneExpressionNotBrain,'corr_fast','average');
    ord_col = BF_ClusterReorder(voxelGeneExpressionBrain','corr_fast','average');

    f = figure('color','w');
    subplot(1,10,1)
    imagesc([voxInfo.isBrain(voxInfo.isBrain);voxInfo.isBrain(~voxInfo.isBrain)])
    subplot(1,10,2:10)
    imagesc([voxelGeneExpressionBrain(ord_row_brain,ord_col);...
                    voxelGeneExpressionNotBrain(ord_row_notBrain,ord_col)])
    colormap(flipud(BF_getcmap('redyellowblue',11,0)))
    title(timePointNow)

case 'subDivision'
    params.thisBrainDiv = 'brain';
    [voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);
    ord_col = BF_ClusterReorder(voxelGeneExpression','corr_fast','average');
    [numVoxels,numGenes] = size(voxelGeneExpression);

    voxelGeneExpressionFore = voxelGeneExpression(voxInfo.isForebrain,:);
    ord_rowFore = BF_ClusterReorder(voxelGeneExpressionFore,'corr_fast','average');
    voxelGeneExpressionMid = voxelGeneExpression(voxInfo.isMidbrain,:);
    ord_rowMid = BF_ClusterReorder(voxelGeneExpressionMid,'corr_fast','average');
    voxelGeneExpressionHind = voxelGeneExpression(voxInfo.isHindbrain,:);
    ord_rowHind = BF_ClusterReorder(voxelGeneExpressionHind,'corr_fast','average');

    labels = zeros(numGenes,1);
    labels(voxInfo.isHindbrain) = 1;
    labels(voxInfo.isMidbrain) = 2;
    labels(voxInfo.isForebrain) = 3;
    [labels,ix] = sort(labels);
    midPoints = arrayfun(@(x)median(find(labels==x)),(1:3));
    firstPoints = arrayfun(@(x)find(labels==x,1,'first'),(1:3));
    labels = labels/3; % for colorbaring

    f = figure('color','w');
    f.Position(3:4) = [796   397];
    ax_labels = subplot(1,15,1);
    imagesc(labels)
    ax_labels.YTick = midPoints;
    ax_labels.YTickLabel = {'hindbrain','midbrain','forebrain'};
    ax_labels.XTick = [];
    ax_gene = subplot(1,15,2:15);
    hold('on');
    imagesc([voxelGeneExpressionHind(ord_rowHind,ord_col);...
                voxelGeneExpressionMid(ord_rowMid,ord_col);...
                    voxelGeneExpressionFore(ord_rowFore,ord_col)])
    % imagesc(voxelGeneExpression(ix,ord_col)) % as a check for consistent labeling
    colormap(flipud(BF_getcmap('redyellowblue',11,0)))
    plot([1,numGenes],(numVoxels-firstPoints(2))*ones(1,2),':k','LineWidth',2)
    plot([1,numGenes],(numVoxels-firstPoints(3))*ones(1,2),':k','LineWidth',2)
    ax_gene.XLim = [1,numGenes];
    ax_gene.YLim = [1,numVoxels];
    ax_gene.XTick = [];
    ax_gene.YTick = [];

    cB = colorbar();
    cB.Label.String = 'Normalized Expression';
    title(sprintf('%s (%u x %u)',timePointNow,numVoxels,numGenes))
end

end
