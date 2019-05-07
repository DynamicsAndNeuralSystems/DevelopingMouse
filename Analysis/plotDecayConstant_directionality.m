function plotDecayConstant_directionality(first_fitting_stat_all,...
                                          second_fitting_stat_all,...
                                          third_fitting_stat_all,...
                                          first_decayConstant,...
                                          second_decayConstant,...
                                          third_decayConstant,...
                                          first_maxDistance,...
                                          second_maxDistance,...
                                          third_maxDistance,...
                                          directionNames,...
                                          dataType,brainDiv,...
                                          dataProcessing)
  % dataType: 'voxel' or 'structure'
  % xData and yData are cells each containing distances and correlation coefficient of all time points
  % dataProcessing: 'original' or 'binned numThresholds=xx'
  % brainDiv: 'forebrain', 'midbrain','hindbrain' or 'wholeBrain'
  % directionNames: a cell containing direction strings ('coronal','sagittal','axial') in order of first, second and third
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

  err=zeros(length(timePoints),length(directionNames));
  decayConstant=zeros(length(timePoints),length(directionNames));
  maxDistance=zeros(length(timePoints),length(directionNames));
  adjustedRsquare=zeros(length(timePoints),length(directionNames));
  for i=1:length(timePoints)
    % obtain errors of the decay constants (95% CI)
    CI=confint(first_fitting_stat_all.(timePoints{i}).fitObject.exp);
    err(i,1)=CI(2,3)-CI(1,3);
    CI=confint(second_fitting_stat_all.(timePoints{i}).fitObject.exp);
    err(i,2)=CI(2,3)-CI(1,3);
    CI=confint(third_fitting_stat_all.(timePoints{i}).fitObject.exp);
    err(i,3)=CI(2,3)-CI(1,3);
    % collect the decay constants
    decayConstant(i,1)=first_decayConstant(i);
    decayConstant(i,2)=second_decayConstant(i);
    decayConstant(i,3)=third_decayConstant(i);
    % collect the max distance
    maxDistance(i,1)=first_maxDistance(i);
    maxDistance(i,2)=second_maxDistance(i);
    maxDistance(i,3)=third_maxDistance(i);
    % collect adjusted R square
    adjustedRsquare(i,1)=first_fitting_stat_all.(timePoints{i}).adjRSquare.exp;
    adjustedRsquare(i,2)=second_fitting_stat_all.(timePoints{i}).adjRSquare.exp;
    adjustedRsquare(i,3)=third_fitting_stat_all.(timePoints{i}).adjRSquare.exp;
  end

  % get the colours needed for plotting
  cmapOut = BF_getcmap('dark2',7,0,0);
  % Specify plotting style for later use
  % theStyle = '-';
  % theLineWidth = 2;
  %% Plot decay constant of exponential fit (3 parameter)
  % f=figure('color','w','Position', get(0, 'Screensize'));
  % same direction different time points
  for j=1:length(directionNames)
    f=figure('color','w','Position', get(0, 'Screensize'));
    for i=1:length(timePoints)
        % set the color
        theColor=cmapOut(i,:);
        % obtain vector of data for a certain direction
        p1=errorbar(maxDistance(i,j),...
                    decayConstant(i,j),...
                    err(i,j),'o','MarkerSize',10,...
                    'LineStyle','none','LineWidth',5*adjustedRsquare(i,j),'Color',theColor);
        text(maxDistance(i,j),...
            decayConstant(i,j)+0.25*10^(-3),num2str(decayConstant(i,j)),...
            'HorizontalAlignment','center','VerticalAlignment','bottom');
        yPosition=linspace(1,0.4,length(timePoints));
        t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
                theColor);
        t.Units='normalized';
        t.Position=[1 yPosition(i)];
        hold on
    end
    xlabel('Max distance (um)','FontSize',16)
    ylabel('Decay constant','FontSize',13)
    str=sprintf('Developing Mouse decay constant against max distance, %s, %s, %s, %s', ...
                dataType, brainDiv,dataProcessing, directionNames{j});
    title(str,'Fontsize',14)
    F=getframe(f);
    % save figure
    str=fullfile('Outs', 'decay_constant_directionality',strcat('decayConstant_voxel_directionality_',directionNames{j},'.jpeg'));
    imwrite(F.cdata,str,'jpeg');
  end
end
  % for i=1:length(timePoints)
  %     % set the color
  %     f=figure('color','w','Position', get(0, 'Screensize'));
  %     theColor=cmapOut(i,:);
  %     % plot first direction
  %     % p1=errorbar(maxDistance{i}(1),decayConstant{i}(1),err{1}(i),'-o','MarkerSize',10,...
  %     %             'LineStyle',theStyle,'LineWidth',...
  %     %             (first_fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,'Color',theColor);
  %     p1=errorbar(maxDistance{i},...
  %                 decayConstant{i},...
  %                 err{i},'o','MarkerSize',10,...
  %                 'LineStyle','none','LineWidth',3,'Color',theColor);
  %     % legend(p1,sprintf('%s direction',directionNames{1}))
  %     text(maxDistance{i}(1),...
  %         decayConstant{i}(1)+0.25*10^(-3),num2str(decayConstant{i}(1)),...
  %         'HorizontalAlignment','center','VerticalAlignment','bottom');
  %     text(maxDistance{i}(1),...
  %         decayConstant{i}(1)+0.25*10^(-3),directionNames{1},...
  %         'HorizontalAlignment','center','VerticalAlignment','top');
  %     text(maxDistance{i}(2),...
  %         decayConstant{i}(2)+0.25*10^(-3),num2str(decayConstant{i}(2)),...
  %         'HorizontalAlignment','center','VerticalAlignment','bottom');
  %     text(maxDistance{i}(2),...
  %         decayConstant{i}(2)+0.25*10^(-3),directionNames{2},...
  %         'HorizontalAlignment','center','VerticalAlignment','top');
  %     text(maxDistance{i}(3),...
  %         decayConstant{i}(3)+0.25*10^(-3),num2str(decayConstant{i}(3)),...
  %         'HorizontalAlignment','center','VerticalAlignment','bottom');
  %     text(maxDistance{i}(3),...
  %         decayConstant{i}(3)+0.25*10^(-3),directionNames{3},...
  %         'HorizontalAlignment','center','VerticalAlignment','top');
      % plot second direction
      % p2=errorbar(maxDistance{i}(2),decayConstant{i}(2),err{2}(i),'-x','MarkerSize',10,...
      %             'LineStyle',theStyle,'LineWidth',...
      %             (second_fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,'Color',theColor);
      % p2=errorbar(arrayfun(@(x) x(2), maxDistance{i}),...
      %             arrayfun(@(x) x(2), decayConstant{i}),...
      %             arrayfun(@(x) x(2), err{i}),'-x','MarkerSize',10,...
      %             'LineStyle',theStyle,'LineWidth',3,'Color',theColor);
      % legend(p2,sprintf('%s direction',directionNames{2}))
      % t2=text(maxDistance{i}(2),...
      %     decayConstant{i}(2)+0.25*10^(-3),num2str(decayConstant{i}(2)),...
      %     'HorizontalAlignment','center');
      % % plot third direction
      % % p3=errorbar(maxDistance{i}(3),decayConstant{i}(3),err{3}(i),'-^','MarkerSize',10,...
      % %             'LineStyle',theStyle,'LineWidth',...
      % %             (third_fitting_stat_all.(timePoints{i}).adjRSquare.exp)*5,'Color',theColor);
      % p3=errorbar(arrayfun(@(x) x(3), maxDistance{i}),...
      %             arrayfun(@(x) x(3), decayConstant{i}),...
      %             arrayfun(@(x) x(3), err{i}),'-^','MarkerSize',10,...
      %             'LineStyle',theStyle,'LineWidth',3,'Color',theColor);
      % legend(p3,sprintf('%s direction',directionNames{3}))
      % t3=text(maxDistance{i}(3),...
      %     decayConstant{i}(3)+0.25*10^(-3),num2str(decayConstant{i}(3)),...
      %     'HorizontalAlignment','center');
%       yPosition=linspace(1,0.4,length(timePoints));
%       t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
%               theColor);
%       t.Units='normalized';
%       t.Position=[1 yPosition(i)];
%       % hold on
%   end
%   xlabel('Max distance (um)','FontSize',16)
%   ylabel('Decay constant','FontSize',13)
%   str=sprintf('Developing Mouse decay constant against max distance, %s, %s, %s', ...
%               dataType, brainDiv,dataProcessing);
%   title(str,'Fontsize',13)
%   F=getframe(f);
% end