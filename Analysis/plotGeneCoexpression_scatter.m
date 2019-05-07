function [f,F]=plotGeneCoexpression_scatter(geneExpressionMatrix)
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat_all{i}(dataIndSelect_all{i},:))','rows','pairwise');
  corrCoeff_all{i}=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances_all{i} = extractDistances(distMat_all{i});
  % plot coexpression against distance
  f=figure('color','w','Position',get(0, 'Screensize'));
  gcf;
  scatter(distances_all{i},corrCoeff_all{i},'.')
  xlabel('Separation Distance (um)','FontSize',16)
  ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
  str = sprintf('Developing Mouse %s',timePoints{i});
  title(str,'Fontsize',19);
  F=getframe(f);
end
