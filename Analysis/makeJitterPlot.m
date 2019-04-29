load('spatialData_NumData_1000.mat')
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
numThresholds=20;
binnedDataCell_all=cell(length(timePoints),1);
for i=1:length(timePoints)
  [binnedDataCell_all{i}]=makeBinnedData(distances_all{i},corrCoeff_all{i},numThresholds);
  % create plot
  f=figure('color','white','Position',get(0,'Screensize'));
  BF_JitteredParallelScatter(binnedDataCell_all{i},true,true,false);
  title(sprintf('Jitter plot of binned data, developing mouse %s, numThresholds=%d',...
                timePoints{i},numThresholds),'Fontsize',19);
  F=getframe(f);
  str=fullfile('Outs','binning_jitter',strcat('binning_jitter_',timePoints{i},'.jpeg'));
  imwrite(F.cdata,str);
end
