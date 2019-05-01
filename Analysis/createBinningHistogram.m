timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('spatialData_NumData_1000.mat');
numThresholds=30;
% make binned data
binnedDataCell_all=cell(length(timePoints),1);
isNormal=cell(length(timePoints),1);
p_values=cell(length(timePoints),1);
for i=1:length(timePoints)
  f=figure('color','w','Position',get(0, 'Screensize'));
  [binnedDataCell_all{i}]=makeBinnedData(distances_all{i},corrCoeff_all{i},numThresholds);
  % plot a histogram for each bin
  for j=1:numThresholds-1
    subplot(ceil(sqrt(numThresholds)),floor(sqrt(numThresholds)),j)
    histogram(binnedDataCell_all{i}{j})
    title(sprintf('Bin %d',j))
    % isNormal{i}=zeros(length(numThresholds-1),1);
    % p_values{i}=zeros(length(numThresholds-1),1);
    % % check if each bin is normally distributed or not
    % [isNormal{i}(j),p_values{i}(j),~,~] = adtest(binnedDataCell_all{i}{j});
  end
  mtit(f,sprintf('Distribution of bins, developing mouse %s',timePoints{i}))
  str=fullfile('Outs','bins_histogram',strcat('bins_histogram_',timePoints{i},'.jpeg'));
  F=getframe(f);
  imwrite(F.cdata,str);
end
