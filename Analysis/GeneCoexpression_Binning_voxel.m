
%% load variables
load('DevMouseGeneExpression.mat')
load('dataDevMouse.mat')

timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

distanceAll=struct();
corrCoeffAll=struct();
for i=1:7
    fileStr=strcat('makeGridData1_',timePoints{i},'.mat');
    distanceAll.(timePoints{i})=load(fileStr,'distance');
    corrCoeffAll.(timePoints{i})=load(fileStr,'corrCoeff');
    fitObjectHere.(timePoints{i})=load(fileStr,'fitObject');
    fHandleAll.(timePoints{i})=load(fileStr,'fHandle');
end

gene3D=MakeMatrix(Exp.Energy.norm);
% Specify plotting style for later use
theStyle = '-';
theLineWidth = 2;
%% [Binning and exponential] Plotting each time point as one colour
% first, get the colours needed
cmapOut = BF_getcmap('dark2',7,0,0);
%% second, plot data from different time points in quantiles in the same graph
s=figure('color','w'); % 7 plots, one for each time point

d2ydx2All=cell(7,1);
for i=1:7

    theColor=cmapOut(i,:);
    xData=extractfield(distanceAll.(timePoints{i}),'distance');
    yData=extractfield(corrCoeffAll.(timePoints{i}),'corrCoeff');
    numThresholds =100;
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
    d2ydx2All{i} = (diff(yPlotData(:))./diff(xPlotData(:)))./diff(xPlotData(:)); % calculate second derivative (later use)
    plot(xPlotData,yPlotData,'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)

    yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    str=sprintf('Developing Mouse binning with threshold number=%d',numThresholds);
    title(str,'Fontsize',18)
    hold on
end
xlabel('Separation Distance (um)','FontSize',16)
ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
s=figureFullScreen(s,true);
%%
f=figure('color','w');
for i=1:7
    xNumbers=1:numThresholds-2;
    theColor=cmapOut(i,:);
    plot(xNumbers,d2ydx2All{i},'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
    yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    hold on
end
xlabel('Approximate bin number','FontSize',16)
ylabel('Gene coepxression second derivative','FontSize',13)
str=sprintf('Developing Mouse gene coexpression decay rate');
title(str,'Fontsize',18)
f=figureFullScreen(f,true);
%% plot mean decay rate as a function of max distance
g=figure('color','w');
for i=1:7
    theColor=cmapOut(i,:);
    plot(max(extractfield(distanceAll.(timePoints{i}),'distance')),mean(d2ydx2All{i}),'-o','MarkerSize',10,'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
        yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    hold on
end
xlabel('Max distance (um)','FontSize',16)
ylabel('Mean gene coepxression second derivative','FontSize',13)
str=sprintf('Developing Mouse mean coexpression decay rate against max distance');
title(str,'Fontsize',16)
g=figureFullScreen(g,true);
%% exponential fit (3 term) on same plot
w=figure('color','w');
for i=1:7
    distanceNow=extractfield(distanceAll.(timePoints{i}),'distance');
    theColor=cmapOut(i,:);
    xData=linspace(min(distanceNow),max(distanceNow),0.1*length(distanceNow));
    p=plot(xData,fHandleAll.(timePoints{i}).fHandle.exp(xData),'-x','MarkerEdgeColor',theColor);

    legend(p,'Exponential fit')
    yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    hold on
end
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    str = sprintf('Developing Mouse 3 parameter exponential fit');
    title(str,'Fontsize',19);
    w=figureFullScreen(w,true);
%% exponential fit, old (structureUnionize) and new (voxel)
q=figure('color','w');
fHand=struct();

for i=1:7
    % plot voxel exponential fit
    distanceNow=extractfield(distanceAll.(timePoints{i}),'distance');
    theColor=cmapOut(i,:);
    xData=linspace(min(distanceNow),max(distanceNow),0.1*length(distanceNow));
    p=plot(xData,fHandleAll.(timePoints{i}).fHandle.exp(xData),'-x','MarkerEdgeColor',theColor);

    hold on
    % plot structureUnionize exponential fit
    nodeSize = 10;

    slice=squeeze(gene3D(i,:,:))'; % makes a matrix of 78 (structure) x 2100 (genes)
    % filter off structures with more than 10% of genes missing
    isMissing=(sum(~isnan(slice),2) <= 0.1*length(geneList));
    slice_clean=slice(~isMissing,:);
    % match the structure regions (because not all time points have all region coordinates available)
    [~,ia,ib]=intersect(char(structures(~isMissing)),dataDevMouse.(timePoints{i}).acronym,'stable');
    % only structures in which coordinates are available are used

    slice_clean=slice_clean(ia,:);
    % compute correlation coefficient between region pairs
    geneCorr{i} = corrcoef(slice_clean','rows','pairwise');
    % extract the correlation coefficients
    corrCoeff=[];
    for j=2:size(geneCorr{i},2)
        corrCoeff=[corrCoeff;geneCorr{i}(1:(j-1),j)];
    end

    % extract the distances needed
    distanceMat=dataDevMouse.(timePoints{i}).distance(ib,ib);
    distance=distanceMat(find(triu(distanceMat,1)));

    if length(corrCoeff)~=length(distance)
        %error('number of correlations not equal to number of distances, graph cannot be plotted')
        continue
    end

    % filter off data points with no coexpression data available
    isMissing_coexpress=isnan(corrCoeff);
    corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
    distance_clean=distance(~isMissing_coexpress);

    % exponential fitting
    [f_handle,~,~] = GiveMeFit(distance_clean,corrCoeff_clean,'exp',1);
    fHand.(timePoints{i}).fHandle.exp=f_handle;

    % plot dots
    xData=linspace(min(distance_clean),max(distance_clean),0.1*length(distance_clean));

    u=plot(xData,fHand.(timePoints{i}).fHandle.exp(xData),'-o','MarkerEdgeColor',theColor); % remove constant term

    legend([p u],'Exponential fit, Voxel','Exponential fit, Structure')
    str=sprintf('Developing Mouse all time points');
    t=title(str);
    set(t, 'FontSize', 19)
    hold on

    yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    hold on
end
xlabel('Separation Distance (um)','FontSize',16)
ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
str = sprintf('Developing Mouse 3 parameter exponential fit');
title(str,'Fontsize',19);
q=figureFullScreen(q,true);

%% exponential fit (3 parameter)
% collect fit objects
decayConstant=struct();
b=figure('color','w');
for i=1:7
    temp=fitObjectHere.(timePoints{i}).fitObject.exp;
    decayConstant.(timePoints{i})=temp.n;
    theColor=cmapOut(i,:);

    plot(max(extractfield(distanceAll.(timePoints{i}),'distance')),decayConstant.(timePoints{i}),'-o','MarkerSize',10,'LineStyle',theStyle,...
        'LineWidth',theLineWidth,'Color',theColor)
    yPosition=linspace(1,0.4,length(timePoints));

    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    t1=text(max(extractfield(distanceAll.(timePoints{i}),'distance')),...
        decayConstant.(timePoints{i})+0.25*10^(-3),num2str(decayConstant.(timePoints{i})),...
        'HorizontalAlignment','center');
    hold on
end

xlabel('Max distance (um)','FontSize',16)
ylabel('Decay constant','FontSize',13)
str=sprintf('Developing Mouse decay constant against max distance');
title(str,'Fontsize',16)
b=figureFullScreen(b,true);
 %% fit max distance^gamma to the data
% % collect max distances and decay constants
% maxDistanceAll=zeros(length(timePoints),1);
% decayConstantAll=zeros(length(timePoints),1);
% for i=1:7
%     maxDistanceAll(i)=max(extractfield(distanceAll.(timePoints{i}),'distance'));
%     decayConstantAll(i)=decayConstant.(timePoints{i});
% end
%
% [fHandle,Stats,c]=GiveMeFit(maxDistanceAll,decayConstantAll,'decayEta');
%
% % exponential fit (3 parameter)
% % collect fit objects
% decayConstant=struct();
% b=figure('color','w');
% for i=1:7
%     temp=fitObjectHere.(timePoints{i}).fitObject.exp;
%     decayConstant.(timePoints{i})=temp.n;
%     theColor=cmapOut(i,:);
%     theStyle = '-';
%     theLineWidth = 2;
%     plot(max(extractfield(distanceAll.(timePoints{i}),'distance')),decayConstant.(timePoints{i}),'-o','MarkerSize',10,'LineStyle',theStyle,...
%         'LineWidth',theLineWidth,'Color',theColor)
%     yPosition=linspace(1,0.4,length(timePoints));
%
%     t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
%             cmapOut(i,:));
%     t.Units='normalized';
%     t.Position=[1 yPosition(i)];
%     t1=text(max(extractfield(distanceAll.(timePoints{i}),'distance')),...
%         decayConstant.(timePoints{i})+0.25*10^(-3),num2str(decayConstant.(timePoints{i})),...
%         'HorizontalAlignment','center');
%     hold on
% end
%
% xlabel('Max distance (um)','FontSize',16)
% ylabel('Decay constant','FontSize',13)
% str=sprintf('Developing Mouse decay constant against max distance');
% title(str,'Fontsize',16)
% hold on
% % func=@(x) c.A.*x.^(-c.n) + c.B;
% plot(maxDistanceAll,fHandle(maxDistanceAll),'-x','MarkerSize',10,'LineStyle',theStyle,'LineWidth',theLineWidth)
%
% b=figureFullScreen(b,true);

%% compute the max log likelihood
% c=fitObjectHere.(timePoints{1}).fitObject.exp;
% x=distanceAll.(timePoints{1}).distance;
% func=@(x,a,n,b) a*exp(-n*x) + b;
% p = mle(x,'pdf',func,'start',[c.A,c.n,c.B]); % estimate parameters
%
