function plotVariance(makeNewFigure)
  timePoints=GiveMeParameter('timePoints');
  xLabel = GiveMeLabelName('sampleSize');
  yLabel = GiveMeLabelName('variance');
  load('variance.mat','variance','incrementVector');
  % plot variance against sampling size
  cmapOut = BF_getcmap('dark2',7,0,0);
  if makeNewFigure
    f=figure('color','w');
  end
  for i=1:length(timePoints)
    theColor = cmapOut(i,:);
    plot(incrementVector,variance{i},'-o','Color',theColor,'LineWidth',3);
    hold on
    % str=sprintf('Variance in decay constant against sample size, %s, numTrials=%d',timePoints{i},samplingNum);
    % title(str)
    % filename=strcat(sprintf('decay_constant_variance_%s_numTrials=%d',timePoints{i},samplingNum),'.jpeg');
    % str=fullfile('Outs','decay_constant_variance',filename);
    % saveas(f,str)
  end
  xlabel(xLabel)
  ylabel(yLabel)
end
