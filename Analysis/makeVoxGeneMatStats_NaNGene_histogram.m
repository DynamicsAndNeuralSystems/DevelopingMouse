function makeVoxGeneMatStats_NaNGene_histogram()
timePoints=GiveMeParameter('timePoints');
for i=1:length(timePoints)
  % create histogram of proportion of nan genes in each time points
  f=figure('color','w');
  load(strcat('voxelGeneCoexpression_',timePoints{i},'.mat'));
  edges = [0 0.1:0.1:0.9 1];
  histogram(propNanGenes,edges);
  xlabel('Proportion of missing genes')
  ylabel('Number of voxels')
  title(sprintf('Frequency distribution of the proportion of missing genes, %s',...
                timePoints{i}), 'FontSize', 14)
  str=fullfile('Outs','voxGeneMatStats_NaNGene_histogram',...
                strcat('voxGeneMatStats_NaNGene_histogram_',timePoints{i},'.jpeg'));
  saveas(f,str)
end
end

% create
