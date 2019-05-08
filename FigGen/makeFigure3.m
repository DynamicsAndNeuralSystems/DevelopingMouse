function makeFigure3()
numData=1000;
numThresholds=20;
thisBrainDiv='wholeBrain';
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');
constantTypes = GiveMeParameter('constantTypes');
%-------------------------------------------------------------------------------
f = figure('color','w');

for j=1:length(constantTypes)
  subplot(2,2,j)
  makeConstantPlot(numData,numThresholds,thisBrainDiv,...
                  false,thisCellType,thisDirection,false,constantTypes{j});
  hold on
end
% f.Position = [0.1300    0.1100    0.3347    0.3412];
str = fullfile('Outs','figure3','figure3.svg');
saveas(f,str)
end
