function makeFigure1(numData,numThresholds)
% plot the voxGeneMat, distMat and cgeMat(correlated gene expression) and the bins

if nargin < 1
    numData = GiveMeParameter('numData');
end
if nargin < 2
    numThresholds = GiveMeParameter('numThresholds');
end

timePoints = GiveMeParameter('timePoints');
timePointNow = 'E11pt5';
thisCellType = 'allCellTypes';
thisBrainDiv = 'wholeBrain';
brainStr = GiveMeFileName(thisBrainDiv);
cellTypeStr = GiveMeFileName(thisCellType);
distanceStr = GiveMeFileName('notScaled');
matTypes = GiveMeParameter('matTypes'); % {'voxGeneMat','distMat','cgeMat'};
timePointIndex = strcmp(timePointNow,timePoints);

%-------------------------------------------------------------------------------
% Plot the voxGeneMat and CGE vs distance graph:
f1 = figure('color','w');
plotMat(timePointNow,thisCellType,thisBrainDiv,matTypes{1},false);

%-------------------------------------------------------------------------------
% Plot the distMat and cgeMat
f2 = figure('color','w');
subplot(2,1,1)
plotMat(timePointNow,thisCellType,thisBrainDiv,matTypes{2},false);
hold on
subplot(2,1,2)
plotMat(timePointNow,thisCellType,thisBrainDiv,matTypes{3},false);

%-------------------------------------------------------------------------------
% Load distance and correlation data:
fileString = sprintf('spatialData_NumData_%d%s%s%s.mat',numData,brainStr,cellTypeStr,...
                    distanceStr);
load(fileString,'distances_all','corrCoeff_all');

%-------------------------------------------------------------------------------
% Plot the distance dependence
f3 = figure('color','w');
BF_PlotQuantiles(distances_all{timePointIndex},corrCoeff_all{timePointIndex},...
              numThresholds,false,false);
xLabel = GiveMeLabelName('originalDistance');
yLabel = GiveMeLabelName('CGE');
xlabel(xLabel);
ylabel(yLabel);

%-------------------------------------------------------------------------------
% Save figures out to svg:
str = fullfile('Outs','figure1','figure1_part1.svg');
saveas(f1,str)
str = fullfile('Outs','figure1','figure1_part2.svg');
saveas(f2,str)
str = fullfile('Outs','figure1','figure1_part3.svg');
saveas(f3,str)

end
