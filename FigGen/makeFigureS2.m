function makeFigureS2(numData,numThresholds)
  % This function plots quantiles with exponential curves separately for brain divisions
  thisCellType='allCellTypes';
  thisDirection='allDirections';
  smallBrainDivisions = GiveMeParameter('smallBrainDivisions');
  scaledDistance = GiveMeParameter('scaledDistance');
  timePoints = GiveMeParameter('timePoints');

  if nargin < 2
    numThresholds = 21; % 21 thresholds by default
  end
  if nargin < 1
    numData = 1000; % 1000 data by default
  end

  % Plot all quantiles together
  f=figure('color','w');
  for j=1:length(smallBrainDivisions)
    subplot(2,2,j)
    for i=1:length(timePoints)
      makeBinningPlot_withExponential(numData,numThresholds,...
                                      smallBrainDivisions{j},false,...
                                      thisCellType,thisDirection,...
                                      timePoints{i},false);
      hold on
    end
    % set y lim according to the spacing of the actual plot
    if j==1
      ylim([-0.2 0.8])
    elseif j==2
      ylim([-0.3 1])
    elseif j==3
      ylim([-0.2 0.9])
    end
    str = GiveMeLabelName(smallBrainDivisions{j});
    title(str)
    hold on
  end
  % Save out:
  str = fullfile('Outs','figureS2','figureS2_part1.svg');
  saveas(f,str)
  for k = 1:length(scaledDistance)
    f = figure('color','w');
    for j=1:length(smallBrainDivisions)
    subplot(2,2,j)
    makeExponentialPlot(numData,numThresholds,...
                        smallBrainDivisions{j},scaledDistance{k},...
                        thisDirection,thisCellType,false);
    str = GiveMeLabelName(smallBrainDivisions{j});
    title(str)
    % set the ylim
    if j==1
      ylim([0 0.8])
      if k==2 % not scaled
        xlim([0 11])
      end
    elseif j==2
      ylim([-0.1 1])
    elseif j==3
      ylim([-0.1 0.9])
      if k==2
        xlim([0 7])
      end
    end
    hold on
    end
    % Save out:
    str = fullfile('Outs','figureS2',sprintf('figureS2_part%d.svg',k+1));
    saveas(f,str)
  end
end
