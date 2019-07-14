function makeFigure5(numData,numThresholds)
  brainDivisions = GiveMeParameter('brainDivisions');
  cellTypes = GiveMeParameter('smallCellTypes');

  if nargin < 2
    numThresholds=GiveMeParameter('numThresholds');
  end
  if nargin < 1
    numData=GiveMeParameter('numData');
  end

  f=figure('color','w');
  for j=1:length(brainDivisions)
    subplot(2,2,j)
    for k=1:length(cellTypes)
      makeConstantPlot(numData,numThresholds,brainDivisions{j},...
                      false,cellTypes{k},'allDirections',...
                      false,'decayConstant',false,false,false,false,true);
      hold on
    end
    str = GiveMeLabelName(brainDivisions{j});
    title(str)
    hold on
  end
  % Save out:
  str = fullfile('Outs','figure5','figure5.svg');
  saveas(f,str)
end
