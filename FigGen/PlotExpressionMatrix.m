function PlotExpressionMatrix(params,timePointNow)

if nargin < 1
    params = GiveMeDefaultParams();
end
if nargin < 2
    timePointNow = 'E11pt5';
end

whatPlot = 'allVoxelOrder';

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

    ord_row = BF_ClusterReorder(voxelGeneExpressionBrain,'corr_fast','average');
    ord_col = BF_ClusterReorder(voxelGeneExpressionBrain','corr_fast','average');

    f = figure('color','w');
    subplot(1,10,1)
    imagesc([voxInfo.isBrain(voxInfo.isBrain);voxInfo.isBrain(~voxInfo.isBrain)])
    subplot(1,10,2:10)
    imagesc([voxelGeneExpressionBrain(ord_row,ord_col);voxelGeneExpressionNotBrain(:,ord_col)])
    colormap(flipud(BF_getcmap('redyellowblue',11,0)))
    title(timePointNow)

case 'subDivision'
    params.thisBrainDiv = 'brain';
    [voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);
    ord_col = BF_ClusterReorder(voxelGeneExpression','corr_fast','average');

    voxelGeneExpressionFore = voxelGeneExpression(voxInfo.isForebrain,:);
    ord_rowFore = BF_ClusterReorder(voxelGeneExpressionFore,'corr_fast','average');
    voxelGeneExpressionMid = voxelGeneExpression(voxInfo.isMidbrain,:);
    ord_rowMid = BF_ClusterReorder(voxelGeneExpressionMid,'corr_fast','average');
    voxelGeneExpressionHind = voxelGeneExpression(voxInfo.isHindbrain,:);
    ord_rowHind = BF_ClusterReorder(voxelGeneExpressionHind,'corr_fast','average');

    labels = zeros(size(voxelGeneExpression,1),1);
    labels(voxInfo.isForebrain) = 1;
    labels(voxInfo.isMidbrain) = 2;
    labels(voxInfo.isHindbrain) = 3;
    labels = sort(labels)/3;

    f = figure('color','w');
    subplot(1,10,1)
    imagesc(labels)
    subplot(1,10,2:10)
    imagesc([voxelGeneExpressionFore(ord_rowFore,ord_col);...
                voxelGeneExpressionMid(ord_rowMid,ord_col);...
                    voxelGeneExpressionHind(ord_rowHind,ord_col)])
    colormap(flipud(BF_getcmap('redyellowblue',11,0)))
    title(timePointNow)

end

end
