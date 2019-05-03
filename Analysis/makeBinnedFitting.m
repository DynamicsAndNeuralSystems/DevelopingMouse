function makeBinnedFitting(numData,numThresholds,useGoodGeneSubset,scaledDistance)
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
if useGoodGeneSubset
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
                  num2str(numThresholds),'_scaled');
  else
    filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
                num2str(numThresholds));
  end
end
load(strcat(filestr,'.mat'));
% create fitting
[fitting_stat_all, decayConstant, maxDistance]=getFitting(xPlotDataAll,yPlotDataAll);

if useGoodGeneSubset
  if scaledDistance
    str=fullfile('Matlab_variables',...
              strcat('fitting_NumData_',num2str(numData),'_',...
              'binnedData_numThresholds_',num2str(numThresholds),'_scaled','_goodGeneSubset','.mat'));
  else
    str=fullfile('Matlab_variables',...
              strcat('fitting_NumData_',num2str(numData),'_',...
              'binnedData_numThresholds_',num2str(numThresholds),'_goodGeneSubset','.mat'));
  end
else
  if scaledDistance
    str=fullfile('Matlab_variables',...
              strcat('fitting_NumData_',num2str(numData),'_',...
                    'binnedData_numThresholds_',num2str(numThresholds),'_scaled','.mat'));
  else
    str=fullfile('Matlab_variables',...
              strcat('fitting_NumData_',num2str(numData),'_',...
                    'binnedData_numThresholds_',num2str(numThresholds),'.mat'));
  end
end
save(str,'fitting_stat_all','decayConstant','maxDistance');
end
% % create fitting (scaled x distance)
% [fitting_stat_all, decayConstant, ~]=getFitting(xPlotDataAll_scaled,yPlotDataAll);
% if useGoodGeneSubset
%   str=fullfile('Matlab_variables',...
%                 strcat('fitting_NumData_',num2str(numData),'_',...
%                 'binnedData_numThresholds_',num2str(numThresholds),'_goodGeneSubset',...
%                 '_scaled','.mat'));
% else
%   str=fullfile('Matlab_variables',...
%               strcat('fitting_NumData_',num2str(numData),'_',...
%               'binnedData_numThresholds_',num2str(numThresholds),'_scaled','.mat'));
% end
% save(str,'fitting_stat_all','decayConstant','maxDistance'); % save max distance of original
% end
