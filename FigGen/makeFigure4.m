function makeFigure4()
numData = 1000;
numThresholds = 21;
smallBrainDivisions = GiveMeParameter('smallBrainDivisions');
f = figure('color','w');
for j=1:length(smallBrainDivisions)
  subplot(2,2,j)
  makeConstantPlot(numData,numThresholds,smallBrainDivisions{j},...
                  false,'allCellTypes','allDirections',...
                  false,'decayConstant')
  str = GiveMeLabelName(smallBrainDivisions{j});
  title(str);
  hold on
end
% Save out:
str = fullfile('Outs','figure4','figure4.svg');
saveas(f,str)
end
