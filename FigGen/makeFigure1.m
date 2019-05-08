function makeFigure1()

numData=1000;
numThresholds=20;
thisBrainDiv='wholeBrain';
scaledDistance=false;
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');
numSubplot=7;
f = figure('color','w');

for j=1:numSubplot
  subplot(1,numSubplot,j)
  makeBinningPlot_withExponential(numData,numThresholds,...
                                  thisBrainDiv,scaledDistance,...
                                  thisCellType,thisDirection,...
                                  timePoints{j},false);
end
f.Position = [49         915        2284         211];

% Save out:
str = fullfile('Outs','figure1','figure1.jpeg');
F = getframe(f);
imwrite(F.cdata,str,'jpeg');
