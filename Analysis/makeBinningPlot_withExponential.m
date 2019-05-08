function [f]=makeBinningPlot_withExponential(numData,numThresholds,...
                                              thisBrainDiv,scaledDistance,...
                                              thisCellType,thisDirection,...
                                              timePointNow,makeNewFigure)
% plot bins with exponential curve fitted on top
timePoints=GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints));
[xPlotDataAll,yPlotDataAll,numThresholds] = makeBinnedData(numData,...
                                                            numThresholds,...
                                                            thisBrainDiv,...
                                                            scaledDistance,...
                                                            thisCellType,...
                                                            thisDirection);

[fitting_stat_all,decayConstant,maxDistance] = makeBinnedFitting(xPlotDataAll,...
                                                                  yPlotDataAll,...
                                                                  numThresholds);

% set file name parameters
brainStr = GiveMeFileName(thisBrainDiv);
cellTypeStr = GiveMeFileName(thisCellType);
if scaledDistance
  distanceStr = GiveMeFileName('scaled');
else
  distanceStr = GiveMeFileName('notScaled');
end

if strcmp(thisDirection,'allDirections')
  fileString = sprintf('spatialData_NumData_%d%s%s%s.mat',numData,brainStr,cellTypeStr,...
                    distanceStr);
else
  fileString = sprintf('directionalityData_%s%s.mat',thisDirection,distanceStr);
end

load(fileString,'distances_all','corrCoeff_all');

cmapOut = BF_getcmap('dark2',7,0,0);
if scaledDistance
  xLabeling=GiveMeLabelName('scaledDistance');
else
  xLabeling=GiveMeLabelName('originalDistance');
end
for i=1:length(timePoints)
    if makeNewFigure
      f = figure('color','w','Position',get(0,'Screensize')); box('on');
    end
    % Binned data:
    PlotQuantiles_diffColor(distances_all{timePointIndex},corrCoeff_all{timePointIndex},...
                            numData,numThresholds,false,cmapOut,false,...
                            timePointNow, thisBrainDiv, thisDirection);

    % Exponential fit:
    plotFitting_singleTimePoint(distances_all,'exp',fitting_stat_all,...
                                xLabeling, 1, ...
                                thisDirection, timePointNow,false, ...
                                thisBrainDiv,thisCellType,true);
    % folderString = sprintf('binning_plot_withExponential%s%s',brainStr,distanceStr);
    % fileString = sprintf('voxel_binning_withExponential%s%s_%s.jpeg',brainStr,...
    %                     distanceStr,timePoints{i});
    % str = fullfile(folderString,fileString);
    % F=getframe(f);
    % imwrite(F.cdata, str, 'jpeg');
end
end
% str = fullfile('Outs','binning_plot','voxel_binning.jpeg');
% imwrite(F.cdata, str, 'jpeg');
