function plotMat(timePointNow,thisCellType,thisBrainDiv,whatMat,makeNewFigure)

cellTypeStr = GiveMeFileName(thisCellType);
brainStr = GiveMeFileName(thisBrainDiv);

switch whatMat
case 'voxGeneMat'
    str = sprintf('voxelGeneCoexpression%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
    s = load(str,'voxGeneMat');
case 'distMat'
    str = sprintf('distMat%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
    s = load(str,'distMat');
case 'cgeMat'
    str = sprintf('cgeMat%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
    s = load(str,'cgeMat');
end

% Normalize:
dataMatrix = s.(whatMat);
dataMatrix = BF_NormalizeMatrix(dataMatrix,'mixedSigmoid');

% Reorder for visualization:
[ord_row,~,~] = BF_ClusterReorder(dataMatrix,'euclidean','average');
[ord_col,~,~] = BF_ClusterReorder(dataMatrix','euclidean','average');

% Plot as image:
if makeNewFigure
    f = figure('color','w')
end
% cMap = BF_getcmap('redblue',11,0,1);
cMap = BF_getcmap('redyellowblue',11,0);
[h,hcb] = imagescwithnan(dataMatrix(ord_row,ord_col), flipud(cMap), [0 0 0], false)
colorbar();

% Give appropriate axes labels:
switch whatMat
case 'voxGeneMat'
    xLabel = GiveMeLabelName('genes');
    yLabel = GiveMeLabelName('voxels');
    title('Gene Expression Matrix');
case 'distMat'
    xLabel = GiveMeLabelName('voxels');
    yLabel = GiveMeLabelName('voxels');
    title('Distance Matrix')
case 'cgeMat'
    xLabel = GiveMeLabelName('voxels');
    yLabel = GiveMeLabelName('voxels');
    title('Correlated Gene Expression');
end

xlabel(xLabel)
ylabel(yLabel)

end
