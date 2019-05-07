function [f,F] = plotFitting(xData_all,fitType,fitting_stat_all, thisDataType, ...
                            xLabel, xDataDensity, dataProcessing,thisDirection,...
                            thisBrainDiv,thisCellType)
  % thisDataType: 'voxel' or 'structure'
  % F is the getframe object for setting figure saving size
  % xDataDensity: >0 and <=1; indicates the proportion of xData to use in plotting
  % thisDirection: 'sagittal', 'coronal','axial' or 'allDirections'
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  % get colors
  cmapOut = BF_getcmap('dark2',7,0,0);
  % plot
  f=figure('color','w','Position', get(0, 'Screensize')); % create new figure
  for i=1:length(timePoints)
      xDataNow=xData_all{i};
      theColor=cmapOut(i,:);
      xData=linspace(min(xDataNow),max(xDataNow),xDataDensity*length(xDataNow));

      switch fitType
          case 'exp'
              p=plot(xData,fitting_stat_all.(timePoints{i}).fHandle.exp(xData),...
                    '-x','MarkerEdgeColor',theColor,'LineWidth',3);
              p.Color=theColor;
              legend(p,sprintf('Exponential fit (exp), %s', thisDataType))
          case 'exp1'
              p=plot(xData,fitting_stat_all.(timePoints{i}).fHandle.exp1(xData),...
                    '-x','MarkerEdgeColor',theColor,'LineWidth',3);
              p.Color=theColor;
              legend(p,sprintf('Exponential fit (exp1), %s', thisDataType))
          case 'exp_1_0'
              p=plot(xData,fitting_stat_all.(timePoints{i}).fHandle.exp_1_0(xData),...
                    '-x','MarkerEdgeColor',theColor,'LineWidth',3);
              p.Color=theColor;
              legend(p,sprintf('Exponential fit (exp_1_0), %s', thisDataType))
          case 'linear'
              p=plot(xData,fitting_stat_all.(timePoints{i}).fHandle.linear(xData),...
                    '-x','MarkerEdgeColor',theColor,'LineWidth',3);
              p.Color=theColor;
              legend(p,sprintf('Linear fit, %s', thisDataType))
          otherwise
              error ('Unknown fit type: ''%s''',fitType);
      end
      yPosition=linspace(1,0.4,length(timePoints));
      t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
              cmapOut(i,:));
      t.Units='normalized';
      t.Position=[1 yPosition(i)];
      hold on
  end
  xlabel(xLabel,'FontSize',16)
  ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
  switch fitType
      case 'exp'
          str = sprintf('Developing Mouse 3 parameter exponential fit, %s, %s, %s, %s',...
                        dataProcessing,thisDirection,thisBrainDiv,thisCellType);
      case 'exp1'
          str = sprintf('Developing Mouse 2 parameter exponential fit, %s, %s, %s, %s',...
                        dataProcessing,thisDirection,thisBrainDiv,thisCellType);
      case 'exp_1_0'
          str = sprintf('Developing Mouse 1 parameter exponential fit, %s, %s, %s, %s',...
                        dataProcessing,thisDirection,thisBrainDiv,thisCellType);
      case 'linear'
          str = sprintf('Developing Mouse linear fit, %s, %s, %s, %s',dataProcessing,...
                        thisDirection,thisBrainDiv,thisCellType);
      otherwise
          str = sprintf('Developing Mouse unknown fit, %s, %s, %s, %s',dataProcessing,...
                        thisDirection,thisBrainDiv,thisCellType);
  end
  title(str,'Fontsize',17);
  % f=figureFullScreen(f,true);
  % set(f, 'PaperPositionMode', 'auto')
  F = getframe(f);
end
