function makeDecayConstantPlot(numData,numThresholds,useGoodGeneSubset,scaledDistance)
% plot decay constant against max distance
if useGoodGeneSubset
  if scaledDistance
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_scaled_goodGeneSubset','.mat');
    filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_goodGeneSubset','.mat'); % for unscaled max distance
  else
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_goodGeneSubset','.mat');
  end
else
  if scaledDistance
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_scaled','.mat');
    filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'.mat');
  else
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'.mat');
  end
end

load(filestr)
if scaledDistance
  % load the unscaled max distance to replace the original scaled max distance
  load(filestr2,'maxDistance')
end

[~,F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                  'original',numData,numThresholds,useGoodGeneSubset);
% save figure
if useGoodGeneSubset
  if scaledDistance
    str=fullfile('Outs', 'decay_constant_goodGeneSubset_scaled',...
              'decayConstant_voxel_scaled_goodGeneSubset.jpeg');
  else
    str=fullfile('Outs', 'decay_constant_goodGeneSubset',...
              'decayConstant_voxel_goodGeneSubset.jpeg');
  end
else
  if scaledDistance
    str=fullfile('Outs', 'decay_constant_scaled','decayConstant_voxel_scaled.jpeg');
  else
    str=fullfile('Outs', 'decay_constant','decayConstant_voxel.jpeg');
  end
end
imwrite(F.cdata,str,'jpeg');
end
