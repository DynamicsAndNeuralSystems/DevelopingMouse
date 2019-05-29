function makeFigure4(numData,numThresholds)
smallBrainDivisions = GiveMeParameter('smallBrainDivisions');

if nargin < 2
  numThresholds = 21; % 21 thresholds by default
end
if nargin < 1
  numData = 1000; % 1000 data by default
end

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
