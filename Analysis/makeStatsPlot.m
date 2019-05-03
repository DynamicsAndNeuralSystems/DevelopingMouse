function [f1,F1,f2,F2]=makeStatsPlot(numData,numThresholds,useGoodGeneSubset, brainDiv)
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
if useGoodGeneSubset
  filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'_goodGeneSubset','.mat')
else
  filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
                num2str(numThresholds),'.mat')
end
load(filestr)
freeParameter_all=zeros(length(timePoints),1);
multiplier_all=zeros(length(timePoints),1);
err_freeParameter_all=zeros(length(timePoints),1);
err_multiplier_all=zeros(length(timePoints),1);
% extract the parameters
for i=1:length(timePoints)
  CI=confint(fitting_stat_all.(timePoints{i}).fitObject.exp);
  err_freeParameter_all(i)=CI(2,2)-CI(1,2);
  err_multiplier_all(i)=CI(2,1)-CI(1,1);
end
% get the colours needed for plotting
cmapOut = BF_getcmap('dark2',7,0,0);
% Specify plotting style for later use
theStyle = '-';
theLineWidth = 2;
% plotting free parameter
f1=figure('color','white','Position',get(0,'Screensize'));
for i=1:length(timePoints)
    % set the color
    theColor=cmapOut(i,:);
    % plot
    errorbar(maxDistance(i),...
            fitting_stat_all.(timePoints{i}).fitObject.exp.B,err_freeParameter_all(i),...
            '-o','MarkerSize',10,'LineStyle',theStyle,'LineWidth',theLineWidth,...
            'Color',theColor)
    yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            theColor);
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    t1=text(maxDistance(i),...
        fitting_stat_all.(timePoints{i}).fitObject.exp.B+0.25*10^(-3),...
        num2str(fitting_stat_all.(timePoints{i}).fitObject.exp.B),...
        'HorizontalAlignment','center');
    hold on
end
xlabel('Max distance (um)','FontSize',16)
ylabel('Free parameter B','FontSize',13)
if useGoodGeneSubset
  title(sprintf('Free parameter against max distance, %s, numData=%d, numThresholds=%d, goodGeneSubset',...
                brainDiv,numData,numThresholds),'FontSize',14)
  str=fullfile('Outs','free_parameter','free_parameter_goodGeneSubset.jpeg');
else
  title(sprintf('Free parameter against max distance, %s, numData=%d, numThresholds=%d',...
                brainDiv,numData,numThresholds),'FontSize',14)
  str=fullfile('Outs','free_parameter','free_parameter.jpeg');
end
F1=getframe(f1);
imwrite(F1.cdata,str,'jpeg');

% plotting multiplier
f2=figure('color','white','Position',get(0,'Screensize'));
for i=1:length(timePoints)
    % set the color
    theColor=cmapOut(i,:);
    % plot
    errorbar(maxDistance(i),...
            fitting_stat_all.(timePoints{i}).fitObject.exp.A,err_multiplier_all(i),...
            '-o','MarkerSize',10,'LineStyle',theStyle,'LineWidth',theLineWidth,...
            'Color',theColor)
    yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            theColor);
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    t1=text(maxDistance(i),...
        fitting_stat_all.(timePoints{i}).fitObject.exp.A+0.25*10^(-3),...
        num2str(fitting_stat_all.(timePoints{i}).fitObject.exp.A),...
        'HorizontalAlignment','center');
    hold on
end
xlabel('Max distance (um)','FontSize',16)
ylabel('Multiplier A','FontSize',13)
if useGoodGeneSubset
  title(sprintf('Multiplier against max distance, %s, numData=%d, numThresholds=%d, goodGeneSubset',...
                brainDiv,numData,numThresholds),'FontSize',14)
  str=fullfile('Outs','multiplier','multiplier_goodGeneSubset.jpeg');
else
  title(sprintf('Multiplier against max distance, %s, numData=%d, numThresholds=%d',...
        brainDiv,numData,numThresholds),'FontSize',14)
  str=fullfile('Outs','multiplier','multiplier.jpeg');
end
F2=getframe(f2);
imwrite(F2.cdata,str,'jpeg');
end
