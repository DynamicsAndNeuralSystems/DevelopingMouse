function [f, F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,dataType,brainDiv,...
                                  dataProcessing)
  % dataType: 'voxel' or 'structure'
  % xData and yData are cells each containing distances and correlation coefficient of all time points
  % dataProcessing: 'original' or 'binned numThresholds=xx'
  % brainDiv: 'forebrain', 'midbrain','hindbrain' or 'wholeBrain'
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  % obtain error of the decay constants (95% CI)
  err=zeros(length(timePoints),1);
  for i=1:length(timePoints)
    CI=confint(fitting_stat_all.(timePoints{i}).fitObject.exp);
    err(i)=CI(2,3)-CI(1,3);
  end
  % get the colours needed for plotting
  cmapOut = BF_getcmap('dark2',7,0,0);
  % Specify plotting style for later use
  theStyle = '-';
  % theLineWidth = 2;
  %% Plot decay constant of exponential fit (3 parameter)
  f=figure('color','w','Position', get(0, 'Screensize'));
  for i=1%:length(timePoints)
      % set the color
      theColor=cmapOut(i,:);
      % plot
      errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,'LineStyle',theStyle,...
          'LineWidth',(fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,'Color',theColor)
      yPosition=linspace(1,0.4,length(timePoints));
      t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
              theColor);
      t.Units='normalized';
      t.Position=[1 yPosition(i)];
      t1=text(maxDistance(i),...
          decayConstant(i)+0.25*10^(-3),num2str(decayConstant(i)),...
          'HorizontalAlignment','center');
      hold on
  end
  xlabel('Max distance (um)','FontSize',16)
  ylabel('Decay constant','FontSize',13)
  str=sprintf('Developing Mouse decay constant against max distance, %s, %s, %s', ...
              dataType, brainDiv,dataProcessing);
  title(str,'Fontsize',13)
  F=getframe(f);
end
