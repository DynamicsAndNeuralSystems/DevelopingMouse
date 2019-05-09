function makeVariance(incrementVector,samplingNum)
  % incrementVector: a vector stating the incremental number of data points tested ...
  % e.g. 100:100:1000
  % samplingNum: the number of trials each data point number is subjected to e.g. 100
timePoints=GiveMeParameter('timePoints');
variance=cell(length(timePoints),1);
decayConstant_samples=cell(length(incrementVector),1);

for k=1:length(incrementVector) % for each sampling size
  decayConstant_samples{k}=cell(length(samplingNum),1);
  for j=1:samplingNum % collect decay constants 100 times
    % create spatial data
    [distances_all,corrCoeff_all,~,~,~]=makeSpatialData(incrementVector(k),'wholeBrain',false,'allCellTypes',false);
    % fit and obtain correlation coefficient (all time points included)
    [~, decayConstant_samples{k}{j}, ~]=getFitting(distances_all,corrCoeff_all,...
                                                    'decayConstant');
    % decayConstant_samples{k}{j} is a vector with decay constants for 7 time points
    clear distances_all corrCoeff_all % saves memory
  end
end
%%
% calculate variance
for i=1:length(timePoints) % for each time point
  variance{i}=zeros(length(incrementVector),1);
  for k=1:length(incrementVector) % for each sample size
    % collect decay constant
    for j=1:samplingNum
      decayConstant_timePoint=cellfun(@(x) x(i), decayConstant_samples{k});
    end
    variance{i}(k)=var(decayConstant_timePoint);
  end
end
% save variance and sample sizes
str=fullfile('Matlab_variables','variance.mat');
save(str,'variance','incrementVector');
%%
% plot variance against sampling size
for i=1:length(timePoints)
  f=figure('color','w');
  plot(incrementVector,variance{i},'-ok')
  xlabel('Sample size','FontSize',16)
  ylabel('Variance in decay constant','FontSize',13)
  str=sprintf('Variance in decay constant against sample size, %s, numTrials=%d',timePoints{i},samplingNum);
  title(str,'FontSize',19)
  filename=strcat(sprintf('decay_constant_variance_%s_numTrials=%d',timePoints{i},samplingNum),'.jpeg');
  str=fullfile('Outs','decay_constant_variance',filename);
  saveas(f,str)
end
end
