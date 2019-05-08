function makeFigure1()
numData=1000;
numThresholds=20;
thisBrainDiv='wholeBrain';
scaledDistance=false;
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');
numSubplot1=7;
numSubplotAll=10;
f=figure('color','w','Position',get(0,'Screensize'));
for j=1:numSubplot1
  subplot(2,4,j)
  makeBinningPlot_withExponential(numData,numThresholds,...
                                  thisBrainDiv,scaledDistance,...
                                  thisCellType,thisDirection,...
                                  timePoints{j},false);
end
