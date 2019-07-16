function makeFigure4(numData,numThresholds)
smallBrainDivisions = GiveMeParameter('smallBrainDivisions');

if nargin < 2
  numThresholds=GiveMeParameter('numThresholds');
end
if nargin < 1
  numData=GiveMeParameter('numData');
end

f = figure('color','w');
for j=1:length(smallBrainDivisions)
  subplot(2,2,j)
  makeConstantPlot(numData,numThresholds,'wholeBrain',...
                  false,'allCellTypes','allDirections',...
                  false,'decayConstant',true,false,false,true,false);
  hold on
  makeConstantPlot(numData,numThresholds,smallBrainDivisions{j},...
                  false,'allCellTypes','allDirections',...
                  false,'decayConstant',false,false,false,true,true);
  str = GiveMeLabelName(smallBrainDivisions{j});
  title(str);
  hold on
end
% Save out:
str = fullfile('Outs','figure4','figure4.svg');
saveas(f,str)
end
