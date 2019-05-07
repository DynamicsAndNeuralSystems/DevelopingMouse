function makeBinnedData(numData,numThresholds,useGoodGeneSubset,thisBrainDiv,scaledDistance)
if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      filestr=strcat('spatialData_NumData_',num2str(numData),'_scaled','_goodGeneSubset','.mat');
    else
      filestr=strcat('spatialData_NumData_',num2str(numData),'_goodGeneSubset','.mat');
    end
  else
    if scaledDistance
      filestr=strcat('spatialData_NumData_',num2str(numData),'_',thisBrainDiv,'_scaled','_goodGeneSubset','.mat');
    else
      filestr=strcat('spatialData_NumData_',num2str(numData),'_',thisBrainDiv,'_goodGeneSubset','.mat');
    end
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      filestr=strcat('spatialData_NumData_',num2str(numData),'_scaled','.mat');
    else
      filestr=strcat('spatialData_NumData_',num2str(numData),'.mat');
    end
  else
    if scaledDistance
      filestr=strcat('spatialData_NumData_',num2str(numData),'_',thisBrainDiv,'_scaled','.mat');
    else
      filestr=strcat('spatialData_NumData_',num2str(numData),'_',thisBrainDiv,'.mat');
    end
  end
end
load(filestr);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
distances_all_scaled=cell(length(timePoints),1);
% Bin the data
[~,~,xPlotDataAll,yPlotDataAll] = plotBinning(distances_all,corrCoeff_all,...
                                              numThresholds,false);
% scale the distance and bin again
% for i=1:length(timePoints)
%   distances_all_scaled{i}=distances_all{i}/max(distances_all{i});
% end
% [~,~,xPlotDataAll_scaled,yPlotDataAll_scaled] = plotBinning(distances_all_scaled,corrCoeff_all,...
%                                                 numThresholds,false);
% save variable
if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
                'numThresholds','_',num2str(numThresholds),'_scaled','_goodGeneSubset','.mat'));
    else
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
                'numThresholds','_',num2str(numThresholds),'_goodGeneSubset','.mat'));
    end
  else
    if scaledDistance
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
                'numThresholds','_',num2str(numThresholds),'_',thisBrainDiv,'_scaled','_goodGeneSubset','.mat'));
    else
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
                'numThresholds','_',num2str(numThresholds),'_',thisBrainDiv,'_goodGeneSubset','.mat'));
    end
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
              'numThresholds','_',num2str(numThresholds),'_scaled','.mat'));
    else
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
              'numThresholds','_',num2str(numThresholds),'.mat'));
    end
  else
    if scaledDistance
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
              'numThresholds','_',num2str(numThresholds),'_',thisBrainDiv,'_scaled','.mat'));
    else
      str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
              'numThresholds','_',num2str(numThresholds),'_',thisBrainDiv,'.mat'));
    end
  end
end
save(str,'xPlotDataAll','yPlotDataAll','numThresholds');
end
