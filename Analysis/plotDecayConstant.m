function [f,F]=plotDecayConstant(fitting_stat_all,decayConstant, maxDistance,dataType,...
                                  brainDiv,numData,numThresholds,...
                                  useGoodGeneSubset,makeNewFigure,...
                                  thisDirection,thisCellType)
% dataType='voxel';
% brainDiv='wholeBrain';
% numData=1000;
% numThresholds=20;
% useGoodGeneSubset=true;
% makeNewFigure=true;
% thisDirection='allDirections';
% thisCellType='allCellTypes';
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
        yPosition=struct();
        yPosition.sagittal=zeros(length(timePoints),1);
        yPosition.coronal=zeros(length(timePoints),1);
        yPosition.axial=zeros(length(timePoints),1);
        if i==1
          yPosition.sagittal(i)=-1.25*10^(-3);
          yPosition.coronal(i)=-1.5*10^(-3);
          yPosition.axial(i)=-1.75*10^(-3);
        elseif i==6
          yPosition.sagittal(i)=0.75*10^(-3);
          yPosition.coronal(i)=1*10^(-3);
          yPosition.axial(i)=1.25*10^(-3);
        elseif i==7
          yPosition.sagittal(i)=0.6*10^(-3);
          yPosition.coronal(i)=0.9*10^(-3);
          yPosition.axial(i)=1.15*10^(-3);
        else
          yPosition.sagittal(i)=0.75*10^(-3);
          yPosition.coronal(i)=1*10^(-3);
          yPosition.axial(i)=1.25*10^(-3);
        end
      elseif ~strcmp(thisCellType,'allCellTypes')
        yPosition=struct();
        yPosition.neuron=zeros(length(timePoints),1);
        yPosition.oligodendrocyte=zeros(length(timePoints),1);
        yPosition.astrocyte=zeros(length(timePoints),1);
        if i==1
          yPosition.neuron(i)=1.8*10^(-3);
          yPosition.oligodendrocyte(i)=1.9*10^(-3);
          yPosition.astrocyte(i)=2.2*10^(-3);
        elseif i==2
          yPosition.neuron(i)=0.9*10^(-3);
          yPosition.oligodendrocyte(i)=1.28*10^(-3);
          yPosition.astrocyte(i)=-1*10^(-3);
        elseif i==3
          yPosition.neuron(i)=1.65*10^(-3);
          yPosition.oligodendrocyte(i)=1.55*10^(-3);
          yPosition.astrocyte(i)=1.75*10^(-3);
        elseif i==4
          yPosition.neuron(i)=1.15*10^(-3);
          yPosition.oligodendrocyte(i)=1*10^(-3);
          yPosition.astrocyte(i)=1.25*10^(-3);
        elseif i==5
          yPosition.neuron(i)=1.2*10^(-3);
          yPosition.oligodendrocyte(i)=0.8*10^(-3);
          yPosition.astrocyte(i)=0.95*10^(-3);
        elseif i==6
          yPosition.neuron(i)=0.75*10^(-3);
          yPosition.oligodendrocyte(i)=0.8*10^(-3);
          yPosition.astrocyte(i)=1.25*10^(-3);
        elseif i==7
          yPosition.neuron(i)=1.8*10^(-3);
          yPosition.oligodendrocyte(i)=1.5*10^(-3);
          yPosition.astrocyte(i)=1.6*10^(-3);
        end
      % else
      %   yPosition=0.75*10^(-3);
      %   yPosition=1*10^(-3);
      %   yPosition=1.25*10^(-3);
      end
      % set parameters for later use
      if strcmp(thisDirection,'sagittal')
        showThis='sagittal';
        thisBackground=theColor;
        thisXPosition=0.85;
      elseif strcmp(thisDirection,'coronal')
        showThis='coronal';
        thisBackground=brighten(theColor,0.5);
        thisXPosition=0.7;
      elseif strcmp(thisDirection,'axial')
        showThis='axial';
        thisBackground=brighten(theColor,-0.5);
        thisXPosition=1;
      elseif strcmp(thisCellType,'neuron')
        showThis='neuron';
        thisBackground=theColor;
        thisXPosition=0.85;
      elseif strcmp(thisCellType,'oligodendrocyte')
        showThis='oligodendrocyte';
        thisBackground=brighten(theColor,0.5);
        thisXPosition=0.65;
      elseif strcmp(thisCellType,'astrocyte')
        showThis='astrocyte';
        thisBackground=brighten(theColor,-0.5);
        thisXPosition=0.98;
      end
      % plot
      if ~strcmp(thisDirection,'allDirections')
        errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,...
                'LineStyle',theStyle,'LineWidth',...
                (fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,'Color',thisBackground)
        t1=text(maxDistance(i),...
            decayConstant(i)+yPosition.(thisDirection)(i),num2str(decayConstant(i)),...
            'Color',thisBackground,'HorizontalAlignment','center');
      elseif ~strcmp(thisCellType,'allCellTypes')
        errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,...
                'LineStyle',theStyle,'LineWidth',...
                (fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,...
                'Color',thisBackground)
        t1=text(maxDistance(i),...
                decayConstant(i)+yPosition.(thisCellType)(i),num2str(decayConstant(i)),...
                'Color',thisBackground,'HorizontalAlignment','center');
      else
        errorbar(maxDistance(i),decayConstant(i),err(i),'-o','MarkerSize',10,...
                'LineStyle',theStyle,'LineWidth',...
                (fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,...
                'Color',theColor)
        t1=text(maxDistance(i),...
                decayConstant(i)+0.25*10^(-3),num2str(decayConstant(i)),...
                'Color',theColor,'HorizontalAlignment','center');
      end
      t1.FontSize=12;
      if (strcmp(thisDirection,'allDirections') & strcmp(thisCellType,'allCellTypes'))
        yPosition=linspace(1,0.4,length(timePoints));
        t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',12,'BackgroundColor',...
                theColor);
        t.Units='normalized';
        t.Position=[1 yPosition(i)];
      else
        yPosition=linspace(0.95,0.65,length(timePoints));
        t=text(0.5,0.5,[timePoints{i} ' ' showThis],'color','k',...
              'FontSize',12,'BackgroundColor',thisBackground);
        t.Units='normalized';
        t.Position=[thisXPosition yPosition(i)];
      end
      hold on
  end
  xlabel('Max distance (um)','FontSize',16)
  ylabel('Decay constant','FontSize',13)
  if useGoodGeneSubset
    str=sprintf('Decay constant against max distance, %s, %s, numData=%d,numThresholds=%d, goodGeneSubset',...
                dataType,brainDiv,numData,numThresholds);
  else
    str=sprintf('Decay constant against max distance, %s, %s, numData=%d,numThresholds=%d',...
                dataType,brainDiv,numData,numThresholds);
  end
  title(str,'Fontsize',14)
  if makeNewFigure
    F=getframe(f);
  else
    F=NaN;
    f=NaN;
  end
end
