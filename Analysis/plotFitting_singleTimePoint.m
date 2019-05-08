function plotFitting_singleTimePoint(xData_all,fitType,fitting_stat_all, ...
                                    xLabel,yLabel,xDataDensity, ...
                                    thisDirection,timePointNow,...
                                    makeNewFigure,thisBrainDiv,thisCellType)
  % thisDataType: 'voxel' or 'structure'
  % F is the getframe object for setting figure saving size
  % xDataDensity: >0 and <=1; indicates the proportion of xData to use in plotting
  % direction: 'sagittal', 'coronal','axial' or 'allDirections'
  % makeNewFigure: true if make new figure, false otherwise
  timePoints=GiveMeParameter('timePoints');
  timePointIndex=find(strcmp(timePointNow,timePoints));
  % get colors
  cmapOut = BF_getcmap('dark2',7,0,0);
  % plot
  if makeNewFigure
    f=figure('color','w'); % create new figure
  end

  xDataNow=xData_all{timePointIndex};
  theColor=cmapOut(timePointIndex,:);
  xData=linspace(min(xDataNow),max(xDataNow),xDataDensity*length(xDataNow));

  switch fitType
      case 'exp'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.exp(xData),...
                '-','MarkerEdgeColor',theColor,'LineWidth',2);
          p.Color=theColor;
          % legend(p,sprintf('Exponential fit (exp), %s', thisDataType))
      case 'exp1'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.exp1(xData),...
                '-','MarkerEdgeColor',theColor,'LineWidth',2);
          p.Color=theColor;
          % legend(p,sprintf('Exponential fit (exp1), %s', thisDataType))
      case 'exp_1_0'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.exp_1_0(xData),...
                '-','MarkerEdgeColor',theColor,'LineWidth',2);
          p.Color=theColor;
          % legend(p,sprintf('Exponential fit (exp_1_0), %s', thisDataType))
      case 'linear'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.linear(xData),...
                '-','MarkerEdgeColor',theColor,'LineWidth',2);
          p.Color=theColor;
          % legend(p,sprintf('Linear fit, %s', thisDataType))
      otherwise
          error('Unknown fit type: ''%s''',fitType);
  end
  xlabel(xLabel,'FontSize',8.5)
  ylabel(yLabel,'FontSize',8.5)
end
