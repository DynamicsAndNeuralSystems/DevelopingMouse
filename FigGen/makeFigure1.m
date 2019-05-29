function makeFigure1(numData,numThresholds)
  % plot the voxGeneMat, distMat and cgeMat(correlated gene expression) and the bins
  timePoints = GiveMeParameter('timePoints');
  timePointNow = 'E11pt5';
  thisCellType = 'allCellTypes';
  thisBrainDiv = 'wholeBrain';
  brainStr = GiveMeFileName(thisBrainDiv);
  cellTypeStr = GiveMeFileName(thisCellType);
  distanceStr = GiveMeFileName('notScaled');
  matTypes = GiveMeParameter('matTypes'); % {'voxGeneMat','distMat','cgeMat'};
  timePointIndex = strcmp(timePointNow,timePoints);
  if nargin < 2
    numThresholds = 21; % 21 thresholds by default
  end
  if nargin < 1
    numData = 1000; % 1000 data by default
  end

  % load distance and correlation data first
  fileString = sprintf('spatialData_NumData_%d%s%s%s.mat',numData,brainStr,cellTypeStr,...
                        distanceStr);
  load(fileString,'distances_all','corrCoeff_all');
  % plots the voxGeneMat and CGE vs distance graph
  f1 = figure('color','w');
  plotMat(timePointNow,thisCellType,thisBrainDiv,matTypes{1},false);

  % plots the distMat and cgeMat
  f2 = figure('color','w');
  subplot(2,1,1)
  plotMat(timePointNow,thisCellType,thisBrainDiv,matTypes{2},false);
  hold on
  subplot(2,1,2)
  plotMat(timePointNow,thisCellType,thisBrainDiv,matTypes{3},false);

  f3 = figure('color','w');
  BF_PlotQuantiles(distances_all{timePointIndex},corrCoeff_all{timePointIndex},...
                  numThresholds,false,false);
  xLabel = GiveMeLabelName('originalDistance');
  yLabel = GiveMeLabelName('CGE');
  xlabel(xLabel);
  ylabel(yLabel);
  % save outs
  str = fullfile('Outs','figure1','figure1_part1.svg');
  saveas(f1,str)
  str = fullfile('Outs','figure1','figure1_part2.svg');
  saveas(f2,str)
  str = fullfile('Outs','figure1','figure1_part3.svg');
  saveas(f3,str)
end
