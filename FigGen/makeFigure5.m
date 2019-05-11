function makeFigure5()
  brainDivisions = GiveMeParameter('brainDivisions');
  cellTypes = GiveMeParameter('cellTypes');
  numData=1000;
  numThresholds=21;
  f=figure('color','w');
  for j=1:length(brainDivisions)
    subplot(2,2,j)
    for k=1:length(cellTypes)
      makeConstantPlot(numData,numThresholds,brainDivisions{j},...
                      false,cellTypes{k},'allDirections',...
                      false,'decayConstant');
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
