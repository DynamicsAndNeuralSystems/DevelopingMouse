function [f,F] = plotFitting_twoDataTypes(first_xData_all,second_xData_all, fitType,fitting_stat_all, firstDataType, secondDataType)
  % thisDataType: 'voxel' or 'structure'
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  % get colors
  cmapOut = BF_getcmap('dark2',7,0,0);
  % plot
  f=figure('color','w','Position', get(0, 'Screensize')); % create new figure
  for i=1:length(timePoints)
      % plot first data type
      xDataNow=first_xData_all{i};
      theColor=cmapOut(i,:);
      xData=linspace(min(xDataNow),max(xDataNow),0.1*length(xDataNow));

      switch fitType
          case 'exp'
              p=plot(xData,fitting_stat_all.(firstDataType).(timePoints{i}).fHandle.exp(xData),'-x','MarkerEdgeColor',theColor);
              % legend(p,sprintf('Exponential fit (exp), %s', firstDataType))
          case 'exp1'
              p=plot(xData,fitting_stat_all.(firstDataType).(timePoints{i}).fHandle.exp1(xData),'-x','MarkerEdgeColor',theColor);
              % legend(p,sprintf('Exponential fit (exp1), %s', firstDataType))
          case 'exp_1_0'
              p=plot(xData,fitting_stat_all.(firstDataType).(timePoints{i}).fHandle.exp_1_0(xData),'-x','MarkerEdgeColor',theColor);
              % legend(p,sprintf('Exponential fit (exp_1_0), %s', firstDataType))
          case 'linear'
              p=plot(xData,fitting_stat_all.(firstDataType).(timePoints{i}).fHandle.linear(xData),'-x','MarkerEdgeColor',theColor);
              % legend(p,sprintf('Linear fit, %s', firstDataType))
          otherwise
              error ('Unknown fit type: ''%s''',fitType);
      end
      hold on
      % plot second data type
      xDataNow=second_xData_all{i};
      xData=linspace(min(xDataNow),max(xDataNow),0.1*length(xDataNow));
      switch fitType
          case 'exp'
              u=plot(xData,fitting_stat_all.(secondDataType).(timePoints{i}).fHandle.exp(xData),'-o','MarkerEdgeColor',theColor);
              legend([p,u],sprintf('Exponential fit (exp), %s', firstDataType),sprintf('Exponential fit (exp), %s', secondDataType))
          case 'exp1'
              u=plot(xData,fitting_stat_all.(secondDataType).(timePoints{i}).fHandle.exp1(xData),'-o','MarkerEdgeColor',theColor);
              legend([p,u],sprintf('Exponential fit (exp1), %s', firstDataType),sprintf('Exponential fit (exp1), %s', secondDataType))
          case 'exp_1_0'
              u=plot(xData,fitting_stat_all.(secondDataType).(timePoints{i}).fHandle.exp_1_0(xData),'-o','MarkerEdgeColor',theColor);
              legend([p,u],sprintf('Exponential fit (exp_1_0), %s', firstDataType),sprintf('Exponential fit (exp_1_0), %s', secondDataType))
          case 'linear'
              u=plot(xData,fitting_stat_all.(secondDataType).(timePoints{i}).fHandle.linear(xData),'-o','MarkerEdgeColor',theColor);
              legend([p,u],sprintf('Linear fit, %s', firstDataType),sprintf('Linear fit, %s', secondDataType))
          otherwise
              error ('Unknown fit type: ''%s''',fitType);
      end
      yPosition=linspace(1,0.4,length(timePoints));
      t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
              cmapOut(i,:));
      t.Units='normalized';
      t.Position=[1 yPosition(i)];

  end
      xlabel('Separation Distance (um)','FontSize',16)
      ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
      switch fitType
          case 'exp'
              str = sprintf('Developing Mouse 3 parameter exponential fit');
          case 'exp1'
              str = sprintf('Developing Mouse 2 parameter exponential fit');
          case 'exp_1_0'
              str = sprintf('Developing Mouse 1 parameter exponential fit');
          case 'linear'
              str = sprintf('Developing Mouse linear fit');
          otherwise
              str = sprintf('Developing Mouse unknown fit');
      end
      title(str,'Fontsize',19);
      % f=figureFullScreen(f,true);
      % set(f, 'PaperPositionMode', 'auto')
      F = getframe(f);
end
