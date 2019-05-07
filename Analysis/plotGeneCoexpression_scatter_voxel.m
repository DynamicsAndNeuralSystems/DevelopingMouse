function [f,F]=plotGeneCoexpression_scatter_voxel(distances,corrCoeff,fitting_stat_all,...
                                                  timePointNow,brainDiv,densityOn, ...
                                                  numThresholds)
                                            % densityOn = true if density is needed, false otherwise
  % plot coexpression against distance
  f=figure('color','w','Position',get(0, 'Screensize'));
  gcf;
  str = sprintf('Developing Mouse %s %s',timePointNow,brainDiv);
  if densityOn
    N=getDensity(distances,corrCoeff,numThresholds);
    % xBin_num=0.1*(max(distances_all)-min(distances_all));
    % yBin_num=xBin_num;
    % nbins=[0.01*length(distances_all(:)) 0.01*length(corrCoeff_all(:))]
    % xThresholds = arrayfun(@(x)quantile(distances,x),linspace(0,1,numThresholds));
    % % xThresholds(end) = xThresholds(end) + eps;
    % yThresholds = arrayfun(@(x)quantile(corrCoeff,x),linspace(0,1,numThresholds));
    % yThresholds(end) = yThresholds(end) + eps;
    % [N,Xedges,Yedges] = histcounts2(distances,corrCoeff,xThresholds,yThresholds);
    % xBin=linspace(min(distances_all),max(distances_all),xBin_num);
    % yBin=linspace(min(corrCoeff_all),max(corrCoeff_all),yBin_num);
    % Bin the data:
    % N=histcounts2(distances_all(:), corrCoeff_all(:), xBin, yBin);
    % Plot scattered data (for comparison):
    subplot(2, 1, 1);
    scatter(distances,corrCoeff,'.');
    set(gca, 'XLim', [min(distances) max(distances)], 'YLim', [min(corrCoeff) max(corrCoeff)]);
    % xl = xticklabels;
    % yl = yticklabels;
    hold on
    % add exponential fitting
    xData=linspace(min(distances),max(distances),0.1*length(distances));
    p=plot(xData,fitting_stat_all.(timePointNow).fHandle.exp(xData));
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    title(str,'Fontsize',19);
    % Plot heatmap:
    subplot(2, 1, 2);
    imagesc(BF_NormalizeMatrix(N,'divideByMax'));
    % imagesc(Xedges, Yedges, N);
    colormap('hot')
    colorbar
    % set(gca, 'XLim', Xedges([1 end]), 'YLim', Yedges([1 end]), 'YDir','normal');
    % ax=gca;
    % ax.XTickLabel = xl;
    % ax.YTickLabel = yl;
    set(gca,'yDir','normal')
    % xlabel('Separation Distance (um)','FontSize',16)
    % ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    title(str,'Fontsize',19);
  else
    scatter(distances,corrCoeff,'.')
    % add exponential fitting
    xData=linspace(min(distances),max(distances),0.1*length(distances));
    p=plot(xData,fitting_stat_all.(timePointNow).fHandle.exp(xData));
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    title(str,'Fontsize',19);
  end
  set(p,'Color','k','LineWidth',5)
  legend(p,'Exponential fit')
  F=getframe(f);
end
