function makeFigure1()
  % plot the voxGeneMat, distMat and cgeMat(correlated gene expression) and the bins
  timePoints = GiveMeParameter('timePoints');
  timePointNow = 'E11pt5';
  thisCellType = 'allCellTypes';
  thisBrainDiv = 'wholeBrain';
  brainStr = GiveMeFileName(thisBrainDiv);
  cellTypeStr = GiveMeFileName(thisCellType);
  distanceStr = GiveMeFileName('notScaled');
  matTypes = GiveMeParameter('matTypes');
  numData = 1000;
  numThresholds = 20;
  timePointIndex = strcmp(timePointNow,timePoints);
  f = figure('color','w');
  % plots the matrices
  for j = 1:length(matTypes)
    subplot(2,2,j)
    plotMat(timePointNow,thisCellType,thisBrainDiv,matTypes{j},false)
  end
  subplot(2,2,4)
  fileString = sprintf('spatialData_NumData_%d%s%s%s.mat',numData,brainStr,cellTypeStr,...
                    distanceStr);
  load(fileString,'distances_all','corrCoeff_all');
  BF_PlotQuantiles(distances_all{timePointIndex},corrCoeff_all{timePointIndex},...
                  numThresholds,false,false);
  xLabel = GiveMeLabelName('originalDistance')
  yLabel = GiveMeLabelName('CGE');
  xlabel(xLabel);
  ylabel(yLabel);
  % save outs
  str = fullfile('Outs','figure1','figure1.svg');
  saveas(f,str)
end
