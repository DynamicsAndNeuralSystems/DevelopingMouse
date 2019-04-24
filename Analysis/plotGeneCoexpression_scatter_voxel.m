function [f,F,distances_all,corrCoeff_all]=plotGeneCoexpression_scatter_voxel(...
                                            voxGeneMat,dataIndSelect,distMat,fitting_stat_all,...
                                            timePointNow,brainDiv,densityOn)
                                            % densityOn = 1 if density is needed, 0 otherwise
  xBin_num=100;
  yBin_num=100;
  % timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  timePointCell=cell(1,1);
  timePointCell{1}=timePointNow;
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
    yBin=linspace(-0.4,1,yBin_num);
    % Bin the data:
    N=histcounts2(distances_all(:), corrCoeff_all(:), xBin, yBin);
    % Plot scattered data (for comparison):
    subplot(2, 1, 1);
    scatter(distances_all,corrCoeff_all,'.');
    set(gca, 'XLim', xBin([1 end]), 'YLim', yBin([1 end]));
    hold on
    % add exponential fitting
    xData=linspace(min(distances_all),max(distances_all),0.1*length(distances_all));
    p=plot(xData,fitting_stat_all.voxel.(timePointCell{1}).fHandle.exp(xData));
    % Plot heatmap:
    subplot(2, 1, 2);
    imagesc(xBin, yBin, N);
    set(gca, 'XLim', xBin([1 end]), 'YLim', yBin([1 end]));
  elseif densityOn==0
    scatter(distances_all,corrCoeff_all,'.')
    set(gca, 'XLim', xBin([1 end]), 'YLim', yBin([1 end]));
    % add exponential fitting
    xData=linspace(min(distances_all),max(distances_all),0.1*length(distances_all));
    p=plot(xData,fitting_stat_all.voxel.(timePointCell{1}).fHandle.exp(xData));
  end
  set(p,'Color','k')
  legend(p,'Exponential fit')
  xlabel('Separation Distance (um)','FontSize',16)
  ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
  str = sprintf('Developing Mouse %s %s',timePointNow,brainDiv);
  title(str,'Fontsize',19);
  F=getframe(f);
end
