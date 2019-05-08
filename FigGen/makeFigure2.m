function makeFigure2()
numData=1000;
numThresholds=20;
thisBrainDiv='wholeBrain';
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');
f=figure('color','w','Position',get(0,'Screensize'));

subplot(2,2,1)
makeExponentialPlot(numData,numThresholds,...
                    thisBrainDiv,false,...
                    thisDirection,thisCellType,false);
subplot(2,2,2)
makeDecayConstantFit(numData,numThresholds,thisBrainDiv,...
                    thisCellType,thisDirection,false,true,false);
subplot(2,2,3)
makeExponentialPlot(numData,numThresholds,...
                    thisBrainDiv,true,...
                    thisDirection,thisCellType,false);
str = fullfile('Outs','figure2','figure2.jpeg');
F=getframe(f);
imwrite(F.cdata,str,'jpeg');
