function makeFigure4_1(numData,numThresholds)
brainDivisions=GiveMeParameter('brainDivisions');
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');
constantTypes = GiveMeParameter('constantTypes');

if nargin < 2
  numThresholds=GiveMeParameter('numThresholds');
end
if nargin < 1
  numData=GiveMeParameter('numData');
end

%-------------------------------------------------------------------------------
% create a structure to hold the data
constantOut = struct();

for k=1:length(brainDivisions)
  f = figure('color','w');

  for j=1:length(constantTypes)
    subplot(1,3,j)
    makeConstantPlot(numData,numThresholds,...
                      brainDivisions{k},...
                      false,thisCellType,...
                      thisDirection,false,...
                      constantTypes{j},...
                      false,false,...
                      false,false,false);
    hold on
  end
  str = GiveMeLabelName(brainDivisions{k});
  title(str)
  str = fullfile('Outs','figure4',sprintf('figure4_%d.svg',k));
  saveas(f,str)
end
end
