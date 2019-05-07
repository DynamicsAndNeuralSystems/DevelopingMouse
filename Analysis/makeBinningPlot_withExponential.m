function makeBinningPlot_withExponential(numData,numThresholds,useGoodGeneSubset,...
                                          thisBrainDiv,scaledDistance)
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

[] = makeBinnedData(numData,numThresholds,true,thisBrainDiv,false);
[] = makeBinnedFitting(numData,numThresholds,true,thisBrainDiv,false);

load(filestr1);
load(filestr2);
cmapOut = BF_getcmap('dark2',7,0,0);
if scaledDistance
  xLabeling='Separation Distance/maxDistance';
else
  xLabeling='Separation Distance (um)';
end
for i=1:length(timePoints)
    f = figure('color','w','Position',get(0,'Screensize')); box('on');
    % Binned data:
    [~,~] = BF_PlotQuantiles_diffColor(distances_all{i},corrCoeff_all{i},numData,...
                                    numThresholds,0,cmapOut,false,...
                                    timePoints{i}, thisBrainDiv, 'allDirections');
    ax = gca;
    ax.XTick = 1:5;
    ax.XTickLabel = timePoints;

    % Exponential fit:
    [~,~] = plotFitting_singleTimePoint(distances_all,'exp',fitting_stat_all, 'voxel', ...
                                      xLabeling, 1, ...
                                      sprintf('binned numThresholds=%d',numThresholds),...
                                      'allDirections', timePoints{i},false, ...
                                      thisBrainDiv,'allCellTypes')
  if useGoodGeneSubset
    if strcmp(thisBrainDiv,'wholeBrain')
      if scaledDistance
        str=fullfile('Outs','binning_plot_withExponential_scaled_goodGeneSubset',...
                  strcat('voxel_binning_withExponential_scaled_goodGeneSubset_',...
                        timePoints{i},'.jpeg'));
      else
        str=fullfile('Outs','binning_plot_withExponential_goodGeneSubset',...
                    strcat('voxel_binning_withExponential_goodGeneSubset_',...
                          timePoints{i},'.jpeg'));
      end
    else
      if scaledDistance
        str=fullfile('Outs',strcat('binning_plot_withExponential','_',thisBrainDiv,...
                                  '_scaled_goodGeneSubset'),...
                            strcat('voxel_binning_withExponential','_',thisBrainDiv,...
                                    '_scaled_goodGeneSubset_',...
                                    timePoints{i},'.jpeg'));
      else
        str=fullfile('Outs',strcat('binning_plot_withExponential','_',thisBrainDiv,...
                  '_goodGeneSubset'),...
                  strcat('voxel_binning_withExponential','_',thisBrainDiv,...
                        '_goodGeneSubset_',timePoints{i},'.jpeg'));
      end
    end
  else
    if strcmp(thisBrainDiv,'wholeBrain')
      if scaledDistance
        str=fullfile('Outs','binning_plot_withExponential',...
                    strcat('voxel_binning_withExponential_scaled_',timePoints{i},'.jpeg'));
      else
        str=fullfile('Outs','binning_plot_withExponential',...
                  strcat('voxel_binning_withExponential_',timePoints{i},'.jpeg'));
      end
    else
      if scaledDistance
        str=fullfile('Outs',strcat('binning_plot_withExponential','_',thisBrainDiv,'_scaled'),...
                    strcat('voxel_binning_withExponential','_',thisBrainDiv,'_scaled_',...
                          timePoints{i},'.jpeg'));
      else
          str=fullfile('Outs',strcat('binning_plot_withExponential','_',thisBrainDiv),...
                      strcat('voxel_binning_withExponential','_',thisBrainDiv,'_',...
                              timePoints{i},'.jpeg'));
      end
    end
  end
  F=getframe(f);
  imwrite(F.cdata, str, 'jpeg');
end
end
% str = fullfile('Outs','binning_plot','voxel_binning.jpeg');
% imwrite(F.cdata, str, 'jpeg');
