% load variables
load('spatialData_2brainDiv.mat');
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
brainDivisions={'forebrain','midbrain','hindbrain'};
% distanceAll=struct();
% corrCoeffAll=struct();
numThresholds =100;
% load variables
v=1:length(brainDivisions);
C=combnk(v,2);

% for i=1:length(timePoints)
%     for d=1:size(C,1)
%         combNow1=C(d,1);
%         combNow2=C(d,2);
%         fileStr=strcat('makeGridData1_2BrainDiv',timePoints{i},brainDivisions{combNow1},brainDivisions{combNow2},'.mat');
%         divStr=strcat(brainDivisions{combNow1},'_',brainDivisions{combNow2});
%         distanceAll.(timePoints{i}).(divStr)=load(fileStr,'distance');
%         corrCoeffAll.(timePoints{i}).(divStr)=load(fileStr,'corrCoeff');
%         fitObjectHere.(timePoints{i}).(divStr)=load(fileStr,'fitObject');
%         fHandleAll.(timePoints{i}).(divStr)=load(fileStr,'fHandle');
%     end
% end
%% plot
% get colours
cmapOut = BF_getcmap('dark2',7,0,0);

%% exponential fit (3 term) on same plot
%
% for i=1:length(timePoints)
%     w=figure('color','w');
%     for d=1:size(C,1)
%         combNow1=C(d,1);
%         combNow2=C(d,2);
%         divStr=strcat(brainDivisions{combNow1},'_',brainDivisions{combNow2});
%         distanceNow=extractfield(distanceAll.(timePoints{i}).(divStr),'distance');
%         theColor=cmapOut(d,:);
%         xData=linspace(min(distanceNow),max(distanceNow),0.1*length(distanceNow));
%         p=plot(xData,fHandleAll.(timePoints{i}).(divStr).fHandle.exp(xData),'-x','MarkerEdgeColor',theColor);
%
%         legend(p,'Exponential fit')
%         yPosition=linspace(0.8,0.6,length(C));
%         t=text(0.5,0.5,char(strcat(brainDivisions{combNow1},'-',brainDivisions{combNow2})),'color','k','FontSize',14,'BackgroundColor',...
%                 cmapOut(d,:));
%         t.Units='normalized';
%         t.Position=[1 yPosition(d)];
%         t.HorizontalAlignment='right';
%         hold on
%     end
%     xlabel('Separation Distance (um)','FontSize',16)
%     ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
%     str = sprintf('Developing Mouse 3 parameter exponential fit, %s', timePoints{i});
%     title(str,'Fontsize',19);
%     w=figureFullScreen(w,true);
%     cd '/projects/kg98/Gladys/Output/GeneCoexpression_Binning_voxel_2BrainDiv_fig'
%     str=strcat('DevelopingMouse_3Parameter_ExponentialFit_',timePoints{i},'.jpg');
%     saveas(w,str)
% end

%% second, plot data from different time points in quantiles in the same graph

% Specify plotting style for later use
theStyle = '-';
theLineWidth = 2;

for i=1:length(timePoints)
    f=figure('color','w','Position',get(0,'Screensize'));
    for d=1:size(C,1)
        combNow1=C(d,1);
        combNow2=C(d,2);
        theColor=cmapOut(d,:);
        xData=spatialData_2brainDiv.(timePoints{i}).(brainDivisions{combNow1}).(brainDivisions{combNow2}).corrCoeff;
        yData=spatialData_2brainDiv.(timePoints{i}).(brainDivisions{combNow1}).(brainDivisions{combNow2}).distances;
        xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
        xThresholds(end) = xThresholds(end) + eps;
        yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);

        xPlotData=zeros(numThresholds-1,1);
        yPlotData=zeros(numThresholds-1,1);
        for g = 1:numThresholds-1
            xPlotData(g)=mean(xThresholds(g:g+1));
            yPlotData(g)=yMeans(g);
            hold on
        end
        plot(xPlotData,yPlotData,'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)


        yPosition=linspace(0.8,0.6,length(C));
        t=text(0.5,0.5,char(strcat(brainDivisions{combNow1},'-',brainDivisions{combNow2})),'color','k','FontSize',14,'BackgroundColor',...
                cmapOut(d,:));
        t.Units='normalized';
        t.Position=[1 yPosition(d)];
        t.HorizontalAlignment='right';
        hold on
    end
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    str = sprintf('Developing Mouse %s binning with threshold number=%d,continuous',timePoints{i},numThresholds);
    title(str,'Fontsize',19);
    F=getframe(f);
    filename=strcat('voxel_binning_Threshold_',numThresholds,'_',timePoints{i},'_continuous','.jpeg')
    str=fullfile('Outs','binning_plot_2brainDiv',filename);
    imwrite(F.cdata,str,'jpeg')
end
%%

% Specify plotting style for later use
% theStyle = '-';
% theLineWidth = 2;
%
% for i=1:7
%     u=figure('color','w');
%     for d=1:size(C,1)
%         combNow1=C(d,1);
%         combNow2=C(d,2);
%         divStr=strcat(brainDivisions{combNow1},'_',brainDivisions{combNow2});
%
%         theColor=cmapOut(d,:);
%
%         xData=extractfield(distanceAll.(timePoints{i}).(divStr),'distance');
%         yData=extractfield(corrCoeffAll.(timePoints{i}).(divStr),'corrCoeff');
%         numThresholds =50;
%
%
%         BF_PlotQuantiles_diffColor(xData,yData,numThresholds,0,theColor,0);
%
%         yPosition=linspace(0.8,0.6,length(C));
%         t=text(0.5,0.5,char(strcat(brainDivisions{combNow1},'-',brainDivisions{combNow2})),'color','k','FontSize',14,'BackgroundColor',...
%                 cmapOut(d,:));
%         t.Units='normalized';
%         t.Position=[1 yPosition(d)];
%         t.HorizontalAlignment='right';
%         hold on
%     end
%     xlabel('Separation Distance (um)','FontSize',16)
%     ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
%     str = sprintf('Developing Mouse %s binning with threshold number=%d,dotted',timePoints{i},numThresholds);
%     title(str,'Fontsize',19);
%     u=figureFullScreen(u,true);
%     cd '/projects/kg98/Gladys/Output/GeneCoexpression_Binning_voxel_2BrainDiv_fig'
%     str=strcat('DevelopingMouse_Binning_Threshold_',numThresholds,'_',timePoints{i},'_dotted','.jpg');
%     saveas(u,str)
% end


%%
% for i=1:7
%     s=figure('color','w'); % 7 plots, one for each time point
%     theColor=cmapOut(i,:);
%     xData=extractfield(distanceAll.(timePoints{i}),'distance');
%     yData=extractfield(corrCoeffAll.(timePoints{i}),'corrCoeff');
%     numThresholds =100;
%     xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
%     xThresholds(end) = xThresholds(end) + eps;
%     yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
%
%     xPlotData=zeros(numThresholds-1,1);
%     yPlotData=zeros(numThresholds-1,1);
%     for g = 1:numThresholds-1
%         xPlotData(g)=mean(xThresholds(g:g+1));
%         yPlotData(g)=yMeans(g);
%         hold on
%     end
%
%     plot(xPlotData,yPlotData,'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
%
%     yPosition=linspace(1,0.4,length(timePoints));
%     t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
%             cmapOut(i,:));
%     t.Units='normalized';
%     t.Position=[1 yPosition(i)];
%     str=sprintf('Developing Mouse binning with threshold number=%d',numThresholds);
%     title(str,'Fontsize',18)
%     hold on
% end
% xlabel('Separation Distance (um)','FontSize',16)
% ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
% s=figureFullScreen(s,true);
%
