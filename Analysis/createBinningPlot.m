timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('spatialData_NumData_1000.mat');
% [~,F,~,~]=plotBinning(distances_all,corrCoeff_all,20)
cmapOut = BF_getcmap('dark2',7,0,0);
for i=1:length(timePoints)
  BF_PlotQuantiles_diffColor(distances_all{i},corrCoeff_all{i},20,0,...
                                    cmapOut,0,timePoints{i});
  str=fullfile('Outs','binning_plot',strcat('voxel_binning_',timePoints{i},'.jpeg'));
  imwrite(F.cdata, str, 'jpeg');
end
% str = fullfile('Outs','binning_plot','voxel_binning.jpeg');
% imwrite(F.cdata, str, 'jpeg');
