clearvars

load('voxelGeneCoexpression_all.mat');
load('corrCoeffAll_distanceAll.mat');
% Initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
fitting_stat_all = struct();
% distances_all = cell(length(timePoints),1);
% corrCoeff_all = cell(length(timePoints),1);
% Get correlation coefficient and distances
for i = 1:length(timePoints)
    % extract the correlation coefficients
    % geneCorr=corrcoef((voxGeneMat_all{i}(dataIndSelect_all{i},:))','rows','pairwise');
    % corrCoeff_all{i}=geneCorr(find(triu(ones(size(geneCorr)),1)));
    % % extract distances from distance matrix
    % distances_all{i} = extractDistances(distMat_all{i});
    % fit
    [fitting_stat_all.(timePoints{i}).adjRSquare, fitting_stat_all.(timePoints{i}).fitObject,fitting_stat_all.(timePoints{i}).fHandle]=fitting_stat({'linear','exp_1_0','exp1','exp'}, '', distances_all{i}, corrCoeff_all{i});
end

%% exponential fit (3 parameter)
decayConstant=zeros(length(timePoints),1);
maxDistance = zeros(length(timePoints),1);
% get the colours needed for plotting
cmapOut = BF_getcmap('dark2',7,0,0);
% Specify plotting style for later use
theStyle = '-';
theLineWidth = 2;
% create the figure
b=figure('color','w');
for i=1:length(timePoints)
    % collect decay constant
    decayConstant(i)=fitting_stat_all.(timePoints{i}).fitObject.exp.n;
    theColor=cmapOut(i,:);
    % collect max distance
    maxDistance(i)=max(distances_all{i});
    % plot
    plot(maxDistance(i),decayConstant(i),'-o','MarkerSize',10,'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
    yPosition=linspace(1,0.4,length(timePoints));
    % first, get the colours needed
    cmapOut = BF_getcmap('dark2',7,0,0);
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    t1=text(maxDistance(i),...
        decayConstant(i)+0.25*10^(-3),num2str(decayConstant(i)),...
        'HorizontalAlignment','center');
    hold on
end

xlabel('Max distance (um)','FontSize',16)
ylabel('Decay constant','FontSize',13)
str=sprintf('Developing Mouse decay constant against max distance');
title(str,'Fontsize',16)
b=figureFullScreen(b,true);
set(b, 'PaperPositionMode', 'auto') % to save a figure that is the same size as the figure on the screen
% save figure
filename=strcat('decayConstant','.jpeg');
str=fullfile('Outs','decay_constant',filename);
saveas(b,str)
%----------------------------------------------------------------------------------------------
% save variables
%----------------------------------------------------------------------------------------------
str=fullfile('Matlab_variables','fitting.mat');
save(str, 'decayConstant', 'maxDistance','fitting_stat_all')
