function PlotExpressionMatrix(timePointNow,params,whatPlot,addPC,doSave)
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
if nargin < 4
    addPC = false;
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

    if addPC
        fprintf(1,'Computing PCA of gene-expression maps...\n');
        zScoredExpression = BF_NormalizeMatrix(voxelGeneExpression,'zscore');
        [~,Y] = pca(zScoredExpression,'algorithm','als',...
                                    'NumComponents',1);
    end

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
    ax = gca();
    hold('on');
    if addPC
        YNorm = BF_NormalizeMatrix(Y,'scaledSigmoid');
        Y_hind =YNorm(voxInfo.isHindbrain);
        Y_mid = YNorm(voxInfo.isMidbrain);
        Y_fore = YNorm(voxInfo.isForebrain);
        YTogether = [Y_hind(ord_rowHind);Y_mid(ord_rowMid);Y_fore(ord_rowFore)];
        imagesc([repmat(YTogether,1,100),[voxelGeneExpressionHind(ord_rowHind,ord_col);...
                            voxelGeneExpressionMid(ord_rowMid,ord_col);...
                            voxelGeneExpressionFore(ord_rowFore,ord_col)]])
        plot(100*ones(2,1),[1,numVoxels],'-k','LineWidth',1)
    else
        imagesc([repmat(labels,1,50),[voxelGeneExpressionHind(ord_rowHind,ord_col);...
                            voxelGeneExpressionMid(ord_rowMid,ord_col);...
                            voxelGeneExpressionFore(ord_rowFore,ord_col)]])
    end

    % imagesc(voxelGeneExpression(ix,ord_col)) % as a check for consistent labeling
    colormap(flipud(BF_getcmap('redyellowblue',11,0)))
    plot([1,numGenes],(firstPoints(2))*ones(1,2),':k','LineWidth',1.5)
    plot([1,numGenes],(firstPoints(3))*ones(1,2),':k','LineWidth',1.5)
    ax.XLim = [1,numGenes];
    ax.YLim = [1,numVoxels];
    ax.XTick = [];
    ax.YTick = midPoints;
    ax.YTickLabel = {'hindbrain','midbrain','forebrain'};

    cB = colorbar();
    cB.Label.String = 'Normalized Expression';
    title(sprintf('%s (%u x %u)',timePointNow,numVoxels,numGenes))
end

%-------------------------------------------------------------------------------
% Save to file:
fileName = fullfile('Outs',sprintf('ExpressionMatrix_%s.png',timePointNow));
saveas(f,fileName,'png')
fprintf(1,'Saved to %s\n',fileName);
close(f);

end
