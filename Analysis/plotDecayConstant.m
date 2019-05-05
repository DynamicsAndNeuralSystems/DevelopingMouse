function [f,F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,dataType,...
                                  brainDiv,numData,numThresholds,...
                                  useGoodGeneSubset,makeNewFigure,thisDirection)
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
  if makeNewFigure
    f=figure('color','w','Position', get(0, 'Screensize'));
  end
  for i=1:length(timePoints)
      % set the color
      theColor=cmapOut(i,:);
      % set y position
      if ~strcmp(thisDirection,'allDirections')
        if i==1
          yPosition_sagittal=-1.25*10^(-3);
          yPosition_coronal=-1.5*10^(-3);
          yPosition_axial=-1.75*10^(-3);
        elseif i==6
          yPosition_sagittal=0.75*10^(-3);
          yPosition_coronal=1*10^(-3);
          yPosition_axial=1.25*10^(-3);
        elseif i==7
          yPosition_sagittal=0.6*10^(-3);
          yPosition_coronal=0.9*10^(-3);
          yPosition_axial=1.15*10^(-3);
        else
          yPosition_sagittal=0.75*10^(-3);
          yPosition_coronal=1*10^(-3);
          yPosition_axial=1.25*10^(-3);
        end
      end
      % plot
      if strcmp(thisDirection,'sagittal')
        errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,...
                'LineStyle',theStyle,'LineWidth',...
                (fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,'Color',theColor)
        t1=text(maxDistance(i),...
            decayConstant(i)+yPosition_sagittal,num2str(decayConstant(i)),'Color',theColor,...
            'HorizontalAlignment','center');
      elseif strcmp(thisDirection,'coronal')
        errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,...
                'LineStyle',theStyle,'LineWidth',...
                (fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,...
                'Color',brighten(theColor,0.5))
        t1=text(maxDistance(i),...
            decayConstant(i)+yPosition_coronal,num2str(decayConstant(i)),...
            'Color',brighten(theColor,0.5),'HorizontalAlignment','center');
      elseif strcmp(thisDirection,'axial')
        errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,...
                'LineStyle',theStyle,'LineWidth',...
                (fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,...
                'Color',brighten(theColor,-0.5))
        t1=text(maxDistance(i),...
            decayConstant(i)+yPosition_axial,num2str(decayConstant(i)),...
            'Color',brighten(theColor,-0.5),...
            'HorizontalAlignment','center');
      elseif strcmp(thisDirection,'allDirections')
        errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,...
                'LineStyle',theStyle,'LineWidth',...
                (fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,'Color',theColor)
        t1=text(maxDistance(i),...
            decayConstant(i)+0.25*10^(-3),num2str(decayConstant(i)),'Color',theColor,...
            'HorizontalAlignment','center');
      end
      t1.FontSize=12;
      yPosition=linspace(0.95,0.65,length(timePoints));
      if strcmp(thisDirection,'sagittal')
        t=text(0.5,0.5,[timePoints{i} ' ' 'sagittal'],'color','k',...
              'FontSize',12,'BackgroundColor',theColor);
        t.Units='normalized';
        t.Position=[0.85 yPosition(i)];
      elseif strcmp(thisDirection,'coronal')
        t=text(0.5,0.5,[timePoints{i} ' ' 'coronal'],'color','k',...
              'FontSize',12,'BackgroundColor',brighten(theColor,0.5));
        t.Units='normalized';
        t.Position=[0.7 yPosition(i)];
      elseif strcmp(thisDirection,'axial')
        t=text(0.5,0.5,[timePoints{i} ' ' 'axial'],'color','k',...
              'FontSize',12,'BackgroundColor',brighten(theColor,-0.5));
        t.Units='normalized';
        t.Position=[1 yPosition(i)];
      elseif strcmp(thisDirection,'allDirections')
        yPosition=linspace(1,0.4,length(timePoints));
        t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',12,'BackgroundColor',...
                theColor);
        t.Units='normalized';
        t.Position=[1 yPosition(i)];
      end
      hold on
  end
  xlabel('Max distance (um)','FontSize',16)
  ylabel('Decay constant','FontSize',13)
  if useGoodGeneSubset
    str=sprintf('Decay constant against max distance, %s, %s, numData=%d, numThresholds=%d, goodGeneSubset',dataType, brainDiv,numData,numThresholds);
  else
    str=sprintf('Decay constant against max distance, %s, %s, numData=%d, numThresholds=%d', dataType, brainDiv,numData,numThresholds);
  end
  title(str,'Fontsize',14)
  if makeNewFigure
    F=getframe(f);
  else
    F=NaN;
    f=NaN;
  end
end
