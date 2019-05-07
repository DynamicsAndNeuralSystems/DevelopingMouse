function makeBinnedFitting_direction(numData,numThresholds,scaledDistance,...
                                    thisDirection)
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% initialize
if scaledDistance
  filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
            num2str(numThresholds),'_',thisDirection,'_scaled_goodGeneSubset');
else
  filestr=strcat('binnedData_NumData_',num2str(numData),'_numThresholds_',...
            num2str(numThresholds),'_',thisDirection,'_goodGeneSubset');
end

load(strcat(filestr,'.mat'));
% if removeBadBin
%   maxDistance = zeros(length(timePoints),1);
%   for i=1:length(timePoints)
%     maxDistance(i)=max(xPlotDataAll{i});
%   end
%   if strcmp(thisDirection,'coronal')
%     xPlotDataAll{1}(19)=[];
%     yPlotDataAll{1}(19)=[];
%   elseif strcmp(thisDirection,'axial')
%     xPlotDataAll{1}(19)=[];
%     yPlotDataAll{1}(19)=[];
%   end
%   [fitting_stat_all, decayConstant, ~]=getFitting(xPlotDataAll,yPlotDataAll);
% else
%   [fitting_stat_all, decayConstant, maxDistance]=getFitting(xPlotDataAll,yPlotDataAll);
% end

% create fitting
[fitting_stat_all, decayConstant, maxDistance]=getFitting(xPlotDataAll,yPlotDataAll);

if scaledDistance
  str=fullfile('Matlab_variables',...
                strcat('fitting_NumData_',num2str(numData),'_',...
                      'binnedData_numThresholds_',num2str(numThresholds),...
                      '_',thisDirection,...
                      '_scaled','_goodGeneSubset','.mat'));
else
  str=fullfile('Matlab_variables',...
              strcat('fitting_NumData_',num2str(numData),'_',...
                      'binnedData_numThresholds_',num2str(numThresholds),...
                      '_',thisDirection,...
                      '_goodGeneSubset','.mat'));
end

save(str,'fitting_stat_all','decayConstant','maxDistance');
end
