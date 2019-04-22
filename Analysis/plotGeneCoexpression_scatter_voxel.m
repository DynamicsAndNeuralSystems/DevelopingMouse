function [f,F,distances_all,corrCoeff_all]=plotGeneCoexpression_scatter_voxel(...
                                            voxGeneMat,dataIndSelect,distMat,timePointNow,brainDiv)
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff_all=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances_all = extractDistances(distMat);
  % plot coexpression against distance
  f=figure('color','w','Position',get(0, 'Screensize'));
  gcf;
  scatter(distances_all,corrCoeff_all,'.')
  xlabel('Separation Distance (um)','FontSize',16)
  ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
  str = sprintf('Developing Mouse %s %s',timePointNow,brainDiv);
  title(str,'Fontsize',19);
  F=getframe(f);
end
