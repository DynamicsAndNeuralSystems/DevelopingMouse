function createSpatialMat(timePointNow,thisCellType,thisBrainDiv,numData)
  cellTypeStr = GiveMeFileName(thisCellType);
  brainStr = GiveMeFileName(thisBrainDiv);
  str=sprintf('voxelGeneCoexpression%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
  load(str,'voxGeneMat','coOrds');
  [distMat,cgeMat] = makeSpatialMat(voxGeneMat,coOrds,numData,timePointNow);
  % save matlab variables
  filename1 = sprintf('distMat%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
  str1 = fullfile('Matlab_variables',filename1);
  save(str1,'distMat')
  filename2 = sprintf('cgeMat%s%s_%s.mat',brainStr,cellTypeStr,timePointNow);
  str2 = fullfile('Matlab_variables',filename2);
  save(str2,'cgeMat')
end
