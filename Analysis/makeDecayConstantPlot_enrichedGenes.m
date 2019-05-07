function makeDecayConstantPlot_enrichedGenes(numData,numThresholds,scaledDistance)
% plot decay constant against max distance
f=figure('color','w','Position', get(0, 'Screensize'));
cellTypes={'neuron','oligodendrocyte','astrocyte'};
if scaledDistance
  for j=1:length(cellTypes)
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_',cellTypes{j},'_scaled','.mat');
    filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                  num2str(numThresholds),'_',cellTypes{j},'.mat'); % for unscaled max distance
    load(filestr)
    load(filestr2,'maxDistance')
    [~,~]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                            numData,numThresholds,true,false,'allDirections',cellTypes{j});
    hold on
  end
else
  for j=1:length(cellTypes)
    filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                    num2str(numThresholds),'_',cellTypes{j},'.mat');
    load(filestr)
    [~,~]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,'voxel','wholeBrain',...
                            numData,numThresholds,true,false,'allDirections',cellTypes{j});
    hold on
  end
end
% save figure
if scaledDistance
  str=fullfile('Outs', 'decay_constant_enrichedGenes_scaled',...
            'decayConstant_voxel_enrichedGenes_scaled.jpeg');
else
  str=fullfile('Outs', 'decay_constant_enrichedGenes',...
            'decayConstant_voxel_enrichedGenes.jpeg');
end
F=getframe(f);
imwrite(F.cdata,str,'jpeg');
end
