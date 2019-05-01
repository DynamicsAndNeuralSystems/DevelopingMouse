timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
for i=1:length(timePoints)
  % create histogram of proportion of nan genes in each time points
  f=figure('color','w','Position',get(0,'Screensize'));
  load(strcat('voxelGeneCoexpression_',timePoints{i},'.mat'));
  edges = [0 0.1:0.1:0.9 1];
  histogram(propNanGenes,edges);
  xlabel('Proportion of missing genes')
  ylabel('Number of voxels')
  title(sprintf('Frequency distribution of the proportion of missing genes, %s',timePoints{i}), 'FontSize', 14)
  F=getframe(f);
  str=fullfile('Outs','voxGeneMatStats_NaNGene_histogram',...
                strcat('voxGeneMatStats_NaNGene_histogram_',timePoints{i},'.jpeg'));
  imwrite(F.cdata,str,'jpeg')
end


% create
