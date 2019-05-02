function makeBinningPlot_withExponential(numData,numThresholds,useGoodGeneSubset)
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
if useGoodGeneSubset
  filestr1=strcat('spatialData_NumData_',num2str(numData),'_goodGeneSubset','.mat');

  filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'_goodGeneSubset','.mat');
else
  filestr1=strcat('spatialData_NumData_',num2str(numData),'.mat');

  filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'.mat');
end
load(filestr1);
load(filestr2);
cmapOut = BF_getcmap('dark2',7,0,0);
for i=1:length(timePoints)
  f = figure('color','w','Position',get(0,'Screensize')); box('on');
  [~,~] = BF_PlotQuantiles_diffColor(distances_all{i},corrCoeff_all{i},numThresholds,0,...
                                    cmapOut,false,timePoints{i});
  [~,~] = plotFitting_singleTimePoint(distances_all,'exp',fitting_stat_all, 'voxel', ...
                              'Separation Distance (um)', 1, ...
                              sprintf('binned numThresholds=%d',numThresholds),...
                              'allDirections', timePoints{i},false)
  if useGoodGeneSubset
    str=fullfile('Outs','binning_plot_withExponential_goodGeneSubset',...
                strcat('voxel_binning_withExponential_goodGeneSubset_',timePoints{i},'.jpeg'));
  else
    str=fullfile('Outs','binning_plot_withExponential',...
                strcat('voxel_binning_withExponential_',timePoints{i},'.jpeg'));
  end
  F=getframe(f);
  imwrite(F.cdata, str, 'jpeg');
end
end
% str = fullfile('Outs','binning_plot','voxel_binning.jpeg');
% imwrite(F.cdata, str, 'jpeg');
