function plotMat(timePointNow,thisCellType,thisBrainDiv,whatMat,makeNewFigure)
  cellTypeStr = GiveMeFileName(thisCellType);
  brainStr = GiveMeFileName(thisBrainDiv);
  if makeNewFigure
    f = figure('color','w')
  end
  switch whatMat
  case 'voxGeneMat'
    str=sprintf('voxelGeneCoexpression%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
    s=load(str,'voxGeneMat');
  case 'distMat'
    str=sprintf('distMat%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
    s=load(str,'distMat');
  case 'cgeMat'
    str=sprintf('cgeMat%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
    s=load(str,'cgeMat');
  end
  cmapOut = BF_getcmap('redblue',11,0,0);
  [h, hcb] = imagescwithnan(s.(whatMat), cmapOut, [0 0 0], false)
  colorbar
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
