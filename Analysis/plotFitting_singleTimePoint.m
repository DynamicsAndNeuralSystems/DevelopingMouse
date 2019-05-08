function plotFitting_singleTimePoint(xData_all,fitType,fitting_stat_all, ...
                                    xLabel,xDataDensity, ...
                                    thisDirection,timePointNow,...
                                    makeNewFigure,thisBrainDiv,thisCellType,showNum)
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
  yPosition=linspace(1,0.4,length(timePoints));
  t=text(0.5,0.5,char(timePoints{timePointIndex}),'color','k',...
          'BackgroundColor',cmapOut(timePointIndex,:));
  t.Units='normalized';
  t.Position=[1 yPosition(timePointIndex)];
  if showNum
    t1=text(0.5,0.5,sprintf('Adj R square = %d',...
                            fitting_stat_all.(timePoints{timePointIndex}).adjRSquare.exp),...
                            'color','k');
    t1.Units='normalized';
    t1.Position=[0.02 0.12];
    % t1.Position=[0.1 yPosition(2)];
    coeff=coeffvalues(fitting_stat_all.(timePoints{timePointIndex}).fitObject.exp);

    t2=text(0.5,0.5,strcat('y= ',num2str(coeff(1)),'*','exp(-',num2str(coeff(3)),'*x)',...
                            '+',num2str(coeff(2))),...
                            'color','k');
    t2.Units='normalized';
    t2.Position=[0.02 0.05];
  end
  xlabel(xLabel)
  ylabel('Gene Coexpression')
end
