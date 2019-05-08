function makeFigure2()
numData=1000;
numThresholds=20;
thisBrainDiv='wholeBrain';
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');

%-------------------------------------------------------------------------------
f = figure('color','w');


hold on
subplot(2,2,2)
makeDecayConstantPlot(numData,numThresholds,thisBrainDiv,...
                      false,thisCellType,thisDirection,false)


% f.Position = [0.1300    0.1100    0.3347    0.3412];
str = fullfile('Outs','figure2','figure2.svg');
saveas(f,str)
end
