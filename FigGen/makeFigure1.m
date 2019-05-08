function makeFigure1()

numData=1000;
numThresholds=20;
thisBrainDiv='wholeBrain';
scaledDistance=false;
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');
numSubplot=7;

% first part of figure 1
f = figure('color','w');
for j=1:numSubplot
  subplot(2,4,j)
  makeBinningPlot_withExponential(numData,numThresholds,...
                                  thisBrainDiv,scaledDistance,...
                                  thisCellType,thisDirection,...
                                  timePoints{j},false);
  end
% f.Position = [49         915        2284         211];
% f.Position=[0.5450    0.1215    0.1539    0.3296];
% Save out:
str = fullfile('Outs','figure1','figure1_part1.svg');
saveas(f,str)

% second part of figure 1
f = figure('color','w');
subplot(1,2,1)
makeExponentialPlot(numData,numThresholds,...
                    thisBrainDiv,false,...
                    thisDirection,thisCellType,false);
                    hold on
                    subplot(2,2,3)
hold on
subplot(1,2,2)
makeExponentialPlot(numData,numThresholds,...
                  thisBrainDiv,true,...
                  thisDirection,thisCellType,false);
% Save out:
str = fullfile('Outs','figure1','figure1_part2.svg');
saveas(f,str)
end
