function makeBinnedData(numData,numThresholds,useGoodGeneSubset,thisBrainDiv)
if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    filestr=strcat('spatialData_NumData_',num2str(numData),'_goodGeneSubset','.mat');
  else
    filestr=strcat('spatialData_NumData_',num2str(numData),'_',thisBrainDiv,'_goodGeneSubset','.mat');
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    filestr=strcat('spatialData_NumData_',num2str(numData),'.mat');
  else
    filestr=strcat('spatialData_NumData_',num2str(numData),'_',thisBrainDiv,'.mat');
  end
end
load(filestr);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
distances_all_scaled=cell(length(timePoints),1);
% Bin the unscaled data
[~,~,xPlotDataAll,yPlotDataAll] = plotBinning(distances_all,corrCoeff_all,...
                                              numThresholds,false);
% scale the distance and bin again
for i=1:length(timePoints)
  distances_all_scaled{i}=distances_all{i}/max(distances_all{i});
end
[~,~,xPlotDataAll_scaled,yPlotDataAll_scaled] = plotBinning(distances_all_scaled,corrCoeff_all,...
                                                numThresholds,false);
% save variable
if useGoodGeneSubset
  str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
                'numThresholds','_',num2str(numThresholds),'_goodGeneSubset','.mat'));
else
  str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
              'numThresholds','_',num2str(numThresholds),'.mat'));
end
save(str,'xPlotDataAll','yPlotDataAll',...
          'xPlotDataAll_scaled','yPlotDataAll_scaled','numThresholds');
end
