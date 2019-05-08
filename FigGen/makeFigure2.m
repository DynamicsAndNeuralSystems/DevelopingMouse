function makeFigure2()
numData=1000;
numThresholds=20;
thisBrainDiv='wholeBrain';
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');

%-------------------------------------------------------------------------------
f = figure('color','w');

subplot(1,3,1)
makeExponentialPlot(numData,numThresholds,...
                    thisBrainDiv,false,...
                    thisDirection,thisCellType,false);
subplot(1,3,2)
makeDecayConstantFit(numData,numThresholds,thisBrainDiv,...
                    thisCellType,thisDirection,false,true,false);
subplot(1,3,3)
makeExponentialPlot(numData,numThresholds,...
                    thisBrainDiv,true,...
                    thisDirection,thisCellType,false);


f.Position = [198   984   893   207];
%
% str = fullfile('Outs','figure2','figure2.jpeg');
% F=getframe(f);
% imwrite(F.cdata,str,'jpeg');
