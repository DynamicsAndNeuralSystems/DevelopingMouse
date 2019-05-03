function makeExponentialPlot(numData,numThresholds,useGoodGeneSubset,...
                            thisBrainDiv,scaledDistance)
if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_scaled_goodGeneSubset','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'_scaled_goodGeneSubset','.mat');
    else
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_goodGeneSubset','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                  '_binnedData_numThresholds_',num2str(numThresholds),'_goodGeneSubset','.mat');
    end
  else
    if scaledDistance
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_',thisBrainDiv,'_scaled_goodGeneSubset','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                      '_binnedData_numThresholds_',num2str(numThresholds),'_',thisBrainDiv,...
                      '_scaled_goodGeneSubset','.mat');
    else
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_',thisBrainDiv,'_goodGeneSubset','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                      '_binnedData_numThresholds_',num2str(numThresholds),'_',thisBrainDiv,...
                      '_goodGeneSubset','.mat');
    end
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                      num2str(numThresholds),'_scaled','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                    '_binnedData_numThresholds_',num2str(numThresholds),'_scaled','.mat');
    else
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                      num2str(numThresholds),'.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                    '_binnedData_numThresholds_',num2str(numThresholds),'.mat');
    end
  else
    if scaledDistance
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                      num2str(numThresholds),'_',thisBrainDiv,'_scaled','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                      '_binnedData_numThresholds_',num2str(numThresholds),'_',...
                      thisBrainDiv,'_scaled','.mat');
    else
      filestr1=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                      num2str(numThresholds),'_',thisBrainDiv,'.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),...
                      '_binnedData_numThresholds_',num2str(numThresholds),...
                      '_',thisBrainDiv,'.mat');
    end
  end
end
load(filestr1);
load(filestr2);

% exponential fit (3 term) on same plot (voxel data)
[~,F]= plotFitting(xPlotDataAll,'exp',fitting_stat_all,'voxel',...
                      'Separation Distance (um)',1,'original','allDirections',thisBrainDiv);

if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      str=fullfile('Outs','exponential_plot_all_scaled_goodGeneSubset',...
                  strcat('exponential_plot_all_scaled_goodGeneSubset','.jpeg'));
    else
      str=fullfile('Outs','exponential_plot_all_goodGeneSubset',...
                  strcat('exponential_plot_all_goodGeneSubset','.jpeg'));
    end
  else
    if scaledDistance
      str=fullfile('Outs',strcat('exponential_plot_all','_',thisBrainDiv,...
                                '_scaled_goodGeneSubset'),...
                          strcat('exponential_plot_all_scaled_goodGeneSubset','.jpeg'));
    else
      str=fullfile('Outs',strcat('exponential_plot_all','_',thisBrainDiv,...
                                '_goodGeneSubset'),...
                          strcat('exponential_plot_all_goodGeneSubset','.jpeg'));
    end
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      str=fullfile('Outs','exponential_plot_all_scaled',...
                  strcat('exponential_plot_all_scaled','.jpeg'));
    else
      str=fullfile('Outs','exponential_plot_all',...
                  strcat('exponential_plot_all','.jpeg'));
    end
  else
    if scaledDistance
      str=fullfile('Outs',strcat('exponential_plot_all','_',thisBrainDiv,...
                                '_scaled'),...
                          strcat('exponential_plot_all_scaled','.jpeg'));
    else
      str=fullfile('Outs',strcat('exponential_plot_all','_',thisBrainDiv),...
                          strcat('exponential_plot_all','.jpeg'));
    end
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
