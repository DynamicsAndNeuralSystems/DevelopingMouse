function makeBinnedFitting(numData,numThresholds,useGoodGeneSubset,thisBrainDiv,...
                          scaledDistance, removeBadBin)
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_scaled','_goodGeneSubset');
    else
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                  num2str(numThresholds),'_goodGeneSubset');
    end
  else
    if scaledDistance
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_',thisBrainDiv,'_scaled','_goodGeneSubset');
    else
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                  num2str(numThresholds),'_',thisBrainDiv,'_goodGeneSubset');
    end
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_scaled');
    else
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                  num2str(numThresholds));
    end
  else
    if scaledDistance
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_',thisBrainDiv,'_scaled');
    else
      filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                    num2str(numThresholds),'_',thisBrainDiv);
    end
  end
end
load(strcat(filestr,'.mat'));
if removeBadBin
  % get the max distance first, then remove the bad bin
  maxDistance = zeros(length(timePoints),1);
  for i=1:length(timePoints)
    maxDistance(i)=max(xPlotDataAll{i});
  end
  if strcmp(thisBrainDiv,'hindbrain')
    xPlotDataAll{5}(19)=[];
    yPlotDataAll{5}(19)=[];
  elseif strcmp(thisBrainDiv,'midbrain')
    xPlotDataAll{4}(19)=[];
    yPlotDataAll{4}(19)=[];
  end
  [fitting_stat_all, decayConstant, ~]=getFitting(xPlotDataAll,yPlotDataAll);
else
  % create fitting
  [fitting_stat_all, decayConstant, maxDistance]=getFitting(xPlotDataAll,yPlotDataAll);
end

if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      str=fullfile('Matlab_variables',...
                    strcat('fitting_NumData_',num2str(numData),'_',...
                          'binnedData_numThresholds_',num2str(numThresholds),...
                          '_scaled','_goodGeneSubset','.mat'));
    else
      str=fullfile('Matlab_variables',...
                  strcat('fitting_NumData_',num2str(numData),'_',...
                          'binnedData_numThresholds_',num2str(numThresholds),...
                          '_goodGeneSubset','.mat'));
    end
  else
    if scaledDistance
      str=fullfile('Matlab_variables',...
                  strcat('fitting_NumData_',num2str(numData),'_',...
                        'binnedData_numThresholds_',num2str(numThresholds),'_',thisBrainDiv,...
                        '_scaled','_goodGeneSubset','.mat'));
    else
      str=fullfile('Matlab_variables',...
                  strcat('fitting_NumData_',num2str(numData),'_',...
                        'binnedData_numThresholds_',num2str(numThresholds),'_',thisBrainDiv,...
                        '_goodGeneSubset','.mat'));
    end
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      str=fullfile('Matlab_variables',...
                    strcat('fitting_NumData_',num2str(numData),'_',...
                          'binnedData_numThresholds_',num2str(numThresholds),'_scaled','.mat'));
    else
      str=fullfile('Matlab_variables',...
                    strcat('fitting_NumData_',num2str(numData),'_',...
                          'binnedData_numThresholds_',num2str(numThresholds),'.mat'));
    end
  else
    if scaledDistance
      str=fullfile('Matlab_variables',...
                  strcat('fitting_NumData_',num2str(numData),'_',...
                        'binnedData_numThresholds_',num2str(numThresholds),'_',...
                        thisBrainDiv,'_scaled','.mat'));
    else
      str=fullfile('Matlab_variables',...
                  strcat('fitting_NumData_',num2str(numData),'_',...
                        'binnedData_numThresholds_',num2str(numThresholds),'_',...
                        thisBrainDiv,'.mat'));
    end
  end
end
save(str,'fitting_stat_all','decayConstant','maxDistance');
end
