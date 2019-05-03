function makeDecayConstantPlot(numData,numThresholds,useGoodGeneSubset,...
                              thisBrainDiv,scaledDistance)
% plot decay constant against max distance
if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
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
                  num2str(numThresholds),'_',thisBrainDiv,'_scaled_goodGeneSubset','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_',thisBrainDiv,'_goodGeneSubset','.mat'); % for unscaled max distance
    else
      filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_',thisBrainDiv,'_goodGeneSubset','.mat');
    end
  end
else
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_scaled','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'.mat');
    else
      filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'.mat');
    end
  else
    if scaledDistance
      filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_',thisBrainDiv,'_scaled','.mat');
      filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_',thisBrainDiv,'.mat');
    else
      filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_',thisBrainDiv,'.mat');
    end
  end
end

load(filestr)
if scaledDistance
  % load the unscaled max distance to replace the original scaled max distance
  load(filestr2,'maxDistance')
end

[~,F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel',thisBrainDiv,...
                  'original',numData,numThresholds,useGoodGeneSubset);
% save figure
if useGoodGeneSubset
  if strcmp(thisBrainDiv,'wholeBrain')
    if scaledDistance
      str=fullfile('Outs', 'decay_constant_goodGeneSubset_scaled',...
                'decayConstant_voxel_scaled_goodGeneSubset.jpeg');
    else
      str=fullfile('Outs', 'decay_constant_goodGeneSubset',...
                'decayConstant_voxel_goodGeneSubset.jpeg');
    end
  else
    if scaledDistance
      str=fullfile('Outs', strcat('decay_constant','_',thisBrainDiv,'_scaled_goodGeneSubset'),...
                strcat('decayConstant_voxel','_',thisBrainDiv,'_scaled_goodGeneSubset.jpeg'));
    else
      str=fullfile('Outs', strcat('decay_constant','_',thisBrainDiv,'_goodGeneSubset'),...
                strcat('decayConstant_voxel','_',thisBrainDiv,'_goodGeneSubset.jpeg'));
    end
  end
else
  if scaledDistance
    str=fullfile('Outs', strcat('decay_constant','_',thisBrainDiv,'_scaled'),...
                strcat('decayConstant_voxel','_',thisBrainDiv,'_scaled.jpeg'));
  else
    str=fullfile('Outs', strcat('decay_constant','_',thisBrainDiv),...
                strcat('decayConstant_voxel','_',thisBrainDiv,'.jpeg'));
  end
end
imwrite(F.cdata,str,'jpeg');
end
