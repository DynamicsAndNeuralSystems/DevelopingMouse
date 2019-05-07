function makeDecayConstantPlot_direction(numData,numThresholds,scaledDistance)
% plot decay constant against max distance
f=figure('color','w','Position', get(0, 'Screensize'));
directions={'sagittal','coronal','axial'};
if scaledDistance
  for j=1:length(directions)
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_',directions{j},'_scaled_goodGeneSubset','.mat');
    filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_',directions{j},'_goodGeneSubset','.mat'); % for unscaled max distance
    load(filestr)
    load(filestr2,'maxDistance')
    [~,~]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                            numData,numThresholds,true,false,directions{j});
    hold on
  end
else
  for j=1:length(directions)
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_',directions{j},'_goodGeneSubset','.mat');
    load(filestr)
    [~,~]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                            numData,numThresholds,true,false,directions{j},'allCellTypes');
    hold on
  end
end
% save figure
if scaledDistance
  str=fullfile('Outs', 'decay_constant_direction_scaled_goodGeneSubset',...
            'decayConstant_voxel_direction_scaled_goodGeneSubset.jpeg');
else
  str=fullfile('Outs', 'decay_constant_direction_goodGeneSubset',...
            'decayConstant_voxel_direction_goodGeneSubset.jpeg');
end
F=getframe(f);
imwrite(F.cdata,str,'jpeg');
end
