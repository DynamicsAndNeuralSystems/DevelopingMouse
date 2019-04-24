function [f,F,distances_all,corrCoeff_all]=plotGeneCoexpression_scatter_voxel(...
                                            voxGeneMat,dataIndSelect,distMat,fitting_stat_all,...
                                            timePointNow,brainDiv,densityOn)
                                            % densityOn = 1 if density is needed, 0 otherwise
  % extract the correlation coefficients
  geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
  corrCoeff_all=geneCorr(find(triu(ones(size(geneCorr)),1)));
  % extract distances from distance matrix
  distances_all = extractDistances(distMat);
  % plot coexpression against distance
  f=figure('color','w','Position',get(0, 'Screensize'));
  gcf;
  str = sprintf('Developing Mouse %s %s',timePointNow,brainDiv);
  if densityOn==1
    % xBin_num=0.1*(max(distances_all)-min(distances_all));
    % yBin_num=xBin_num;
    [N,Xedges,Yedges] = histcounts2(distances_all(:),corrCoeff_all(:));
    % xBin=linspace(min(distances_all),max(distances_all),xBin_num);
    % yBin=linspace(min(corrCoeff_all),max(corrCoeff_all),yBin_num);
    % Bin the data:
    % N=histcounts2(distances_all(:), corrCoeff_all(:), xBin, yBin);
    % Plot scattered data (for comparison):
    subplot(2, 1, 1);
    scatter(distances_all,corrCoeff_all,'.');
    set(gca, 'XLim', Xedges([1 end]), 'YLim', Yedges([1 end]));
    hold on
    % add exponential fitting
    xData=linspace(min(distances_all),max(distances_all),0.1*length(distances_all));
    p=plot(xData,fitting_stat_all.voxel.(timePointNow).fHandle.exp(xData));
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    title(str,'Fontsize',19);
    % Plot heatmap:
    subplot(2, 1, 2);
    imagesc(Xedges, Yedges, N);
    colorbar
    set(gca, 'XLim', Xedges([1 end]), 'YLim', Yedges([1 end]), 'YDir','normal');
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    title(str,'Fontsize',19);
  elseif densityOn==0
    scatter(distances_all,corrCoeff_all,'.')
    % add exponential fitting
    xData=linspace(min(distances_all),max(distances_all),0.1*length(distances_all));
    p=plot(xData,fitting_stat_all.voxel.(timePointNow).fHandle.exp(xData));
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    title(str,'Fontsize',19);
  end
  set(p,'Color','k','LineWidth',5)
  legend(p,'Exponential fit')
  F=getframe(f);
end
