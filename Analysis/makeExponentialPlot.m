function makeExponentialPlot(numData,numThresholds,useGoodGeneSubset,scaledDistance)
if useGoodGeneSubset
    filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                  num2str(numThresholds),'_goodGeneSubset','.mat');

    if scaledDistance
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'_goodGeneSubset_scaled','.mat');
    else
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'_goodGeneSubset','.mat');
    end
else
  filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                  num2str(numThresholds),'.mat');
  if scaledDistance
    filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'_scaled','.mat');
  else
    filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'.mat');
  end
end
load(filestr1);
load(filestr2);

% exponential fit (3 term) on same plot (voxel data)
if scaledDistance
  [~,F]= plotFitting(xPlotDataAll_scaled,'exp',fitting_stat_all,'voxel',...
                      'Separation Distance/maxDistance',1,'original','allDirections');
else
  [~,F]= plotFitting(xPlotDataAll,'exp',fitting_stat_all,'voxel',...
                      'Separation Distance (um)',1,'original','allDirections');
end
if useGoodGeneSubset
  if scaledDistance
    str=fullfile('Outs','exponential_plot_all_scaled_goodGeneSubset',...
                strcat('exponential_plot_all_scaled_goodGeneSubset','.jpeg'));
  else
    str=fullfile('Outs','exponential_plot_all_goodGeneSubset',...
                strcat('exponential_plot_all_goodGeneSubset','.jpeg'));
  end
else
  if scaledDistance
    str=fullfile('Outs','exponential_plot_all_scaled',...
                strcat('exponential_plot_all_scaled','.jpeg'));
  else
    str=fullfile('Outs','exponential_plot_all',...
                strcat('exponential_plot_all','.jpeg'));
  end
end
imwrite(F.cdata, str, 'jpeg');
end
%% exponential fit, gene subset (later)
% load('fitting_oligodendrocyteProgenitor.mat');
% [~,F]= plotFitting(spatialData.voxel.distancesAll,'exp',fitting_stat_all,'voxel','Separation Distance (um)',...
%                   0.1,'original');
% str = fullfile('Outs','exponential_plot','voxel_expFit_xScaled.jpeg');
% imwrite(F.cdata, str, 'jpeg');
