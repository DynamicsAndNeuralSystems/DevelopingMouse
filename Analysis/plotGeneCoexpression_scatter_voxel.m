function [f,F,distances_all,corrCoeff_all]=plotGeneCoexpression_scatter_voxel(...
                                            voxGeneMat,dataIndSelect,distMat,...
                                            timePointNow,brainDiv,densityOn)
                                            % densityOn = 1 if density is needed, 0 otherwise
  xBin_num=100;
  yBin_num=100;
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff_all=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances_all = extractDistances(distMat);
  % plot coexpression against distance
  f=figure('color','w','Position',get(0, 'Screensize'));
  gcf;
  if densityOn==1
    xBin=linspace(0,max(distances_all),xBin_num);
    yBin=linspace(1,-0.4,yBin_num);
    % Bin the data:
    [N,~,~]=histcounts2(distances_all(:), corrCoeff_all(:), xBin, yBin);
    % Plot scattered data (for comparison):
    subplot(2, 1, 1);
    scatter(distances_all,corrCoeff_all,'.');
    set(gca, 'XLim', xBin([1 end]), 'YLim', yBin([1 end]));
    % Plot heatmap:
    subplot(2, 1, 2);
    imagesc(xBin, yBin, N);
    set(gca, 'XLim', xBin([1 end]), 'YLim', yBin([1 end]));
  elseif densityOn==0
    scatter(distances_all,corrCoeff_all,'.')
  end
  xlabel('Separation Distance (um)','FontSize',16)
  ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
  str = sprintf('Developing Mouse %s %s',timePointNow,brainDiv);
  title(str,'Fontsize',19);
  F=getframe(f);
end
