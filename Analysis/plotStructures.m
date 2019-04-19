function [figure] = plotStructures(xData, yData, whatplot, dotColorCell, labelCell, divisionLabel, numData, plotTitle)
  % whatplot: scatter or scatter3
  % dotColorCell is a cell containing dot colors as elements
  f = figure('color','w');
  dotColors = arrayfun(@(x) rgbconv(dotColorCell{x})',...
                                          1:numData,'UniformOutput',0);
  dotColors = [dotColors{:}]';

  nodeSize = 50;
  whatplot(xData,yData,nodeSize,dotColors,'fill','MarkerEdgeColor','k')

  % Add labels:
  xDataRange = range(xData);
  for i = 1:numData
      text(xData(i)+0.04*xDataRange,yData(i),labelCell{i},...
                          'color',brighten(dotColors(i,:),-0.3))
  end

  % And for major divisions:
  divisionLabels = categorical(divisionLabel);
  theDivisions = unique(divisionLabels);
  numDivisions = length(theDivisions);
  for i = 1:numDivisions
      % Put each major region in the center of those points
      centrePoint = [mean(xData(divisionLabels==theDivisions(i))),mean(yData(divisionLabels==theDivisions(i)))];
      find_1 = find(divisionLabels==theDivisions(i),1);
      text(centrePoint(1),centrePoint(2),char(theDivisions(i)), ...
                  'color','k','FontSize',14,'BackgroundColor',dotColors(find_1,:))
  end
  t=title(plotTitle);
  set(t,'Fontsize',18)
  f=figureFullScreen(f,true);
  set(f, 'PaperPositionMode', 'auto')
end
