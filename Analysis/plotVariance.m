function plotVariance()
  timePoints=GiveMeParameter('timePoints');
  xLabel = GiveMeLabelName('sampleSize');
  yLabel = GiveMeLabelName('variance');
  load('variance.mat','variance','incrementVector');
  % plot variance against sampling size
  for i=1:length(timePoints)
    f=figure('color','w');
    plot(incrementVector,variance{i},'-ok')
    xlabel(xLabel)
    ylabel(yLabel)
    str=sprintf('Variance in decay constant against sample size, %s, numTrials=%d',timePoints{i},samplingNum);
    title(str)
    filename=strcat(sprintf('decay_constant_variance_%s_numTrials=%d',timePoints{i},samplingNum),'.jpeg');
    str=fullfile('Outs','decay_constant_variance',filename);
    saveas(f,str)
  end
end
