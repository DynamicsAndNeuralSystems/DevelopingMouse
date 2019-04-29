timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('spatialData_NumData_1000.mat');
numThresholds=20;
binnedDataCell_all=cell(length(timePoints),1);
cmapOut = BF_getcmap('dark2',7,0,0);
for i=1:length(timePoints)
  [binnedDataCell_all{i}]=makeBinnedData(distances_all{i},corrCoeff_all{i},numThresholds);
  [~,F]=BF_PlotQuantiles_diffColor_Jitter(distances_all{i},corrCoeff_all{i},...
                                          binnedDataCell_all{i},cmapOut,timePoints{i});
  str=fullfile('Outs','binning_plot_with_jitter',strcat('binning_plot_with_jitter_',...
              timePoints{i},'.jpeg'));
  imwrite(F.cdata, str, 'jpeg');
end
% str = fullfile('Outs','binning_plot','voxel_binning.jpeg');
% imwrite(F.cdata, str, 'jpeg');
