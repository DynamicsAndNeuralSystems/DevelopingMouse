function [f,F] = plotFitting_singleTimePoint(xData_all,fitType,fitting_stat_all, thisDataType, ...
                            xLabel, xDataDensity, dataProcessing,direction, ...
                            timePointNow,makeNewFigure,thisBrainDiv)
  % thisDataType: 'voxel' or 'structure'
  % F is the getframe object for setting figure saving size
  % xDataDensity: >0 and <=1; indicates the proportion of xData to use in plotting
  % direction: 'sagittal', 'coronal','axial' or 'allDirections'
  % makeNewFigure: true if make new figure, false otherwise
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  timePointIndex=find(cellfun(@(x) strcmp(timePointNow,x), timePoints));
  % get colors
  cmapOut = BF_getcmap('dark2',7,0,0);
  % plot
  if makeNewFigure
    f=figure('color','w','Position', get(0, 'Screensize')); % create new figure
  else
    f=NaN;
  end

  xDataNow=xData_all{timePointIndex};
  theColor=cmapOut(timePointIndex,:);
  xData=linspace(min(xDataNow),max(xDataNow),xDataDensity*length(xDataNow));

  switch fitType
      case 'exp'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.exp(xData),...
                '-x','MarkerEdgeColor',theColor);
          p.Color=theColor;
          legend(p,sprintf('Exponential fit (exp), %s', thisDataType))
      case 'exp1'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.exp1(xData),...
                '-x','MarkerEdgeColor',theColor);
          p.Color=theColor;
          legend(p,sprintf('Exponential fit (exp1), %s', thisDataType))
      case 'exp_1_0'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.exp_1_0(xData),...
                '-x','MarkerEdgeColor',theColor);
          p.Color=theColor;
          legend(p,sprintf('Exponential fit (exp_1_0), %s', thisDataType))
      case 'linear'
          p=plot(xData,fitting_stat_all.(timePoints{timePointIndex}).fHandle.linear(xData),...
                '-x','MarkerEdgeColor',theColor);
          p.Color=theColor;
          legend(p,sprintf('Linear fit, %s', thisDataType))
      otherwise
          error ('Unknown fit type: ''%s''',fitType);
  end
  yPosition=linspace(1,0.4,length(timePoints));
  t=text(0.5,0.5,char(timePoints{timePointIndex}),'color','k','FontSize',14,'BackgroundColor',...
          cmapOut(timePointIndex,:));
  t.Units='normalized';
  t.Position=[1 yPosition(timePointIndex)];

  t1=text(0.5,0.5,sprintf('Adjusted R square = %d',...
                          fitting_stat_all.(timePoints{timePointIndex}).adjRSquare.exp),...
                          'color','k','FontSize',20);
  t1.Units='normalized';
  t1.Position=[0.3 yPosition(2)];
  coeff=coeffvalues(fitting_stat_all.(timePoints{timePointIndex}).fitObject.exp);

  t2=text(0.5,0.5,strcat('y= ',num2str(coeff(1)),'*','exp(-',num2str(coeff(3)),'*x)',...
                          '+',num2str(coeff(2))),...
                          'color','k','FontSize',20);
  t2.Units='normalized';
  t2.Position=[0.3 yPosition(2)-0.1];

  xlabel(xLabel,'FontSize',16)
  ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
  switch fitType
      case 'exp'
          str = sprintf('Developing Mouse 3 parameter exponential fit, %s, %s, %s',...
                        dataProcessing,direction,thisBrainDiv);
      case 'exp1'
          str = sprintf('Developing Mouse 2 parameter exponential fit, %s, %s, %s',...
                        dataProcessing,direction,thisBrainDiv);
      case 'exp_1_0'
          str = sprintf('Developing Mouse 1 parameter exponential fit, %s, %s, %s',...
                        dataProcessing,direction,thisBrainDiv);
      case 'linear'
          str = sprintf('Developing Mouse linear fit, %s, %s, %s',dataProcessing,direction,thisBrainDiv);
      otherwise
          str = sprintf('Developing Mouse unknown fit, %s, %s, %s',dataProcessing,direction);
  end
  title(str,'Fontsize',16);
  % f=figureFullScreen(f,true);
  % set(f, 'PaperPositionMode', 'auto')
  if makeNewFigure
    F = getframe(f);
  else
    F = NaN;
  end
end
