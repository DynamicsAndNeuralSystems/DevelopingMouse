function makeExponentialPlot_direction(numData,numThresholds,scaledDistance,...
                                        thisDirection,thisBrainDiv)
if scaledDistance
  filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                num2str(numThresholds),'_',thisDirection,'_scaled_goodGeneSubset','.mat');
  filestr2=strcat('fitting_NumData_',num2str(numData),...
                '_binnedData_numThresholds_',num2str(numThresholds),...
                '_',thisDirection,'_scaled_goodGeneSubset','.mat');
else
  filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                num2str(numThresholds),'_',thisDirection,'_goodGeneSubset','.mat');
  filestr2=strcat('fitting_NumData_',num2str(numData),...
                '_binnedData_numThresholds_',num2str(numThresholds),...
                '_',thisDirection,'_goodGeneSubset','.mat');
end
load(filestr1);
load(filestr2);
% exponential fit (3 term) on same plot (voxel data)
if scaledDistance
  xLabeling='Separation Distance/maxDistance';
else
  xLabeling='Separation Distance (um)';
end
[~,F]= plotFitting(xPlotDataAll,'exp',fitting_stat_all,'voxel',...
                  xLabeling,1,'original',thisDirection,thisBrainDiv);

if scaledDistance
  str=fullfile('Outs',strcat('exponential_plot_all_',thisDirection,'_scaled_goodGeneSubset'),...
              strcat('exponential_plot_all_',thisDirection,'_scaled_goodGeneSubset','.jpeg'));
else
  str=fullfile('Outs',strcat('exponential_plot_all_',thisDirection,'_goodGeneSubset'),...
              strcat('exponential_plot_all_',thisDirection,'_goodGeneSubset','.jpeg'));
end

imwrite(F.cdata, str, 'jpeg');
end
%% exponential fit, gene subset (later)
% load('fitting_oligodendrocyteProgenitor.mat');
% [~,F]= plotFitting(spatialData.voxel.distancesAll,'exp',fitting_stat_all,'voxel','Separation Distance (um)',...
%                   0.1,'original');
% str = fullfile('Outs','exponential_plot','voxel_expFit_xScaled.jpeg');
% imwrite(F.cdata, str, 'jpeg');
