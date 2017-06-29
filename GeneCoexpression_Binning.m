
%%
load('DevMouseGeneExpression.mat')
load('dataDevMouse.mat')
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

%%  initial conditions
% specify 7 time points 
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

gene3D=MakeMatrix(Exp.Energy.norm);
%% [Exponential fit] 
% plot coexpression against distance for each of the 7 time points, and fitting
fHandles=cell(length(timePoints),1);
fitObjects=cell(length(timePoints),1);
%b=figure('color','w');
for i=1:7
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

    %divisions=dataDevMouse.(timePoints{i}).division(colorIndex); % division follows the fill colour (for the time being)
    % check if number of corrCoeff is same as distance
    if length(corrCoeff)~=length(distance)
        %error('number of correlations not equal to number of distances, graph cannot be plotted')
        continue
    end

    % filter off data points with no coexpression data available
    isMissing_coexpress=isnan(corrCoeff);
    corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
    distance_clean=distance(~isMissing_coexpress);

    %divisions_clean=divisions(~isMissing_coexpress);
     %Plot correlation against distance

    %match colors

    %numRegions=length(distance_clean);
    
    % exponential fitting
     [f_handle,~,c] = GiveMeFit(distance_clean,corrCoeff_clean,'exp',1);
     fHandles{i}=f_handle;
     fitObjects{i}=c;
end    
%% [Binning and exponential] Plotting each time point as one colour
% first, get the colours needed
cmapOut = BF_getcmap('dark2',7,0,0);
%% second, plot data from different time points in quantiles in the same graph, and exponential fit
% plot coexpression against distance for each of the 7 time points, and fitting
rmbData=cell(7,3); % 7 time points, 2 things to remember (xdata, ydata, 1 colors)
nodeSize = 10;
for k=1:7
    s=figure('color','w');
    %b=figure('color','w');
    for i=1:7
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

        %divisions=dataDevMouse.(timePoints{i}).division(colorIndex); % division follows the fill colour (for the time being)
        % check if number of corrCoeff is same as distance
        if length(corrCoeff)~=length(distance)
            %error('number of correlations not equal to number of distances, graph cannot be plotted')
            continue
        end

        % filter off data points with no coexpression data available
        isMissing_coexpress=isnan(corrCoeff);
        corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
        distance_clean=distance(~isMissing_coexpress);

        %divisions_clean=divisions(~isMissing_coexpress);
         %Plot correlation against distance

        %match colors

        %numRegions=length(distance_clean);

        % plot in bins
        if i~=k
            plotColor='k';
            %BF_PlotQuantiles_diffColor_meanOnly(distance_clean,corrCoeff_clean,20,0,plotColor,0); % plot immediately
            
            hold on

        else
            plotColor=cmapOut(i,:);
        end
        
        % plot dots
        
        if i~=k
            dataColor='k';
%             s=scatter(distance_clean,corrCoeff_clean,nodeSize,dataColor,'LineWidth',0.3); % plot black immediately
%             set(s,'Marker','.')
%             ylim([-0.4 0.8])
%             yPosition=linspace(1,0.4,length(timePoints));
%             t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
%                     cmapOut(i,:));
%             t.Units='normalized';
%             t.Position=[1 yPosition(i)];
        else
            rmbData{k,1}=distance_clean;
            rmbData{k,2}=corrCoeff_clean;
            rmbData{k,3}=cmapOut(i,:);
            
            ylim([-0.4 0.8])
            yPosition=linspace(1,0.4,length(timePoints));
            t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
                    cmapOut(i,:));
            t.Units='normalized';
            t.Position=[1 yPosition(i)];
        end
        
        hold on
        
        xlabel('Separation Distance (um)','FontSize',16)
        ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
        xlim([0 9000])

        hold on
    end
    s=scatter(rmbData{k,1},rmbData{k,2},nodeSize,rmbData{k,3},'LineWidth',0.3);
    set(s,'Marker','.')
    hold on
    
    xData=linspace(min(rmbData{k,1}),max(rmbData{k,1}),0.3*length(rmbData{k,1}));
    c=fitObjects{k};
    fHand=fHandles{k};
    p=plot(xData,fHand(xData),'-x');
    set(p,'Color','k')
    legend(p,'Exponential fit')
    str=sprintf('Developing Mouse %s Highlighted',timePoints{k});
    t=title(str);
    set(t, 'FontSize', 19)
    hold on
    
    %BF_PlotQuantiles_diffColor(rmbData{k,1},rmbData{k,2},20,0,rmbData{k,3},0);    
    
    %f = figure('color','w'); box('on');
    
    theStyle = '-';
    theLineWidth = 2;
    theColor=rmbData{k,3};
    xData=rmbData{k,1};
    yData=rmbData{k,2};
    numThresholds = 10;
    xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
    xThresholds(end) = xThresholds(end) + eps;
    yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
    
    xPlotData=zeros(numThresholds-1,1);
    yPlotData=zeros(numThresholds-1,1);
    for g = 1:numThresholds-1
        %plot(xThresholds(g:g+1),ones(2,1)*yMeans(g),'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
        xPlotData(g)=mean(xThresholds(g:g+1));
        yPlotData(g)=yMeans(g);
        hold on
    end
    plot(xPlotData,yPlotData,'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
    
end


%% [Binning and exponential, global, exclude dots] Plotting each time point as one colour
% first, get the colours needed
cmapOut = BF_getcmap('dark2',7,0,0);
%% second, plot data from different time points in quantiles in the same graph, and exponential fit
% plot coexpression against distance for each of the 7 time points, and fitting
rmbData=cell(7,3); % 7 time points, 2 things to remember (xdata, ydata, 1 colors)
s=figure('color','w');
nodeSize = 10;

regionPairs=cell(length(timePoints),1);
acronymPair=cell(length(timePoints),1);
for k=1:7
    %b=figure('color','w');
    for i=1:7
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
       
        
        regionPairs{i}=cell(length(distance_clean),1); % create empty cell array of region pairs for current time point
        % create acronym cell array for ease of coding
        acronymCell=cell(length(ib),length(ib));
        acronym_relevant=dataDevMouse.(timePoints{i}).acronym(ib);
        for h=1:length(ib) % cell row
            for d=1:length(ib) % cell column
                acronymCell{h,d}={acronym_relevant{h},acronym_relevant{d}}; % each cell entry is a label pair
            end
        end
        % extract the needed acronym pairs
        acronymPair{i}={};
        for j=2:size(acronymCell,2)
            acronymPair{i}=vertcat(acronymPair{i},acronymCell(1:(j-1),j));
        end

        %divisions=dataDevMouse.(timePoints{i}).division(colorIndex); % division follows the fill colour (for the time being)
        % check if number of corrCoeff is same as distance
        if length(corrCoeff)~=length(distance)
            %error('number of correlations not equal to number of distances, graph cannot be plotted')
            continue
        end

        % filter off data points with no coexpression data available
        isMissing_coexpress=isnan(corrCoeff);
        corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
        distance_clean=distance(~isMissing_coexpress);
        maxDistClean{i}=max(distance_clean);


        %divisions_clean=divisions(~isMissing_coexpress);
         %Plot correlation against distance

        %match colors

        %numRegions=length(distance_clean);

        % plot in bins
        if i~=k
            plotColor='k';
            %BF_PlotQuantiles_diffColor_meanOnly(distance_clean,corrCoeff_clean,20,0,plotColor,0); % plot immediately
            
            hold on

        else
            plotColor=cmapOut(i,:);
        end
        
        % plot dots
        
        if i~=k
            dataColor='k';
%             s=scatter(distance_clean,corrCoeff_clean,nodeSize,dataColor,'LineWidth',0.3); % plot black immediately
%             set(s,'Marker','.')
%             ylim([-0.4 0.8])
%             yPosition=linspace(1,0.4,length(timePoints));
%             t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
%                     cmapOut(i,:));
%             t.Units='normalized';
%             t.Position=[1 yPosition(i)];
        else
            rmbData{k,1}=distance_clean;
            rmbData{k,2}=corrCoeff_clean;
            rmbData{k,3}=cmapOut(i,:);
            
            ylim([-0.4 0.8])
            yPosition=linspace(1,0.4,length(timePoints));
            t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
                    cmapOut(i,:));
            t.Units='normalized';
            t.Position=[1 yPosition(i)];
        end
        
        hold on
        
        xlabel('Separation Distance (um)','FontSize',16)
        ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
        xlim([0 9000])

        hold on
    end
%     s=scatter(rmbData{k,1},rmbData{k,2},nodeSize,rmbData{k,3},'LineWidth',0.3);
%     set(s,'Marker','.')
%     hold on
    
    xData=linspace(min(rmbData{k,1}),max(rmbData{k,1}),0.1*length(rmbData{k,1}));
    c=fitObjects{k};
    fHand=fHandles{k}; 
    p=plot(xData,fHand(xData)-c.B,'-x'); % remove constant term 
    set(p,'Color',rmbData{k,3})
    legend(p,'Exponential fit')
    str=sprintf('Developing Mouse all time points');
    t=title(str);
    set(t, 'FontSize', 19)
    hold on
    
    %BF_PlotQuantiles_diffColor(rmbData{k,1},rmbData{k,2},20,0,rmbData{k,3},0);    
    
    %f = figure('color','w'); box('on');
    
    theStyle = '-';
    theLineWidth = 2;
    theColor=rmbData{k,3};
    xData=rmbData{k,1};
    yData=rmbData{k,2};
    numThresholds = 10;
    xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
    xThresholds(end) = xThresholds(end) + eps;
    yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);
    
    xPlotData=zeros(numThresholds-1,1);
    yPlotData=zeros(numThresholds-1,1);
    for g = 1:numThresholds-1
        %plot(xThresholds(g:g+1),ones(2,1)*yMeans(g),'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
        xPlotData(g)=mean(xThresholds(g:g+1));
        yPlotData(g)=yMeans(g);
    end
    plot(xPlotData,yPlotData,'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
    hold on
end


%% [Binning and exponential, global] plot global coexpression against distance
%symbol={'o','^','<','v','^','square','diamond'};
% make empty matrices to store the distances and correlations
distanceGlobal=[];
corrCoeffGlobal=[];

%f=figure('color','w'); hold on
for i=1:7 % for each time point
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
    % extract the colours needed
%     dataDevMouse.(timePoints{i}).color=dataDevMouse.(timePoints{i}).color(ib,:);
%     colorIndex=zeros(length(distance),1);
%     edgeColorIndex=zeros(length(distance),1);
%     for j=1:length(distance) % find indices of extracted entries in the distance matrix
%         [iq,ir]=ind2sub4up(j);
%         colorIndex(j)=iq;
%         edgeColorIndex(j)=ir;

    
%     dotColors=dataDevMouse.(timePoints{i}).color(colorIndex);
%     edgeColors=dataDevMouse.(timePoints{i}).color(edgeColorIndex);
    
    %divisions=dataDevMouse.(timePoints{i}).division(colorIndex); % division follows the fill colour (for the time being)
    % check if number of corrCoeff is same as distance
    if length(corrCoeff)~=length(distance)
        %error('number of correlations not equal to number of distances, graph cannot be plotted')
        continue
    end


    % filter off data points with no coexpression data available
    isMissing_coexpress=isnan(corrCoeff);
    corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
    distance_clean=distance(~isMissing_coexpress);
%     dotColors_clean=dotColors(~isMissing_coexpress);
%     edgeColors_clean=edgeColors(~isMissing_coexpress);
    if i==1
        distanceGlobal=distance_clean;
        corrCoeffGlobal=corrCoeff_clean;
    else
        distanceGlobal=vertcat(distanceGlobal,distance_clean);
        corrCoeffGlobal=vertcat(corrCoeffGlobal,corrCoeff_clean);
    end


end
    
[f_handle,~,c] = GiveMeFit(distanceGlobal,corrCoeffGlobal,'exp',true);
fHandles_global=f_handle;
fitObjects_global=c;

xData=linspace(min(distanceGlobal),max(distanceGlobal),0.3*length(distanceGlobal));
c=fitObjects_global;
fHand=fHandles_global;
f=figure('color','w');
p=plot(xData,fHand(xData),'-x');
set(p,'Color','k')
legend(p,'Exponential fit')
xlabel('Separation Distance (um)','FontSize',16)
ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
xlim([0 9000])
ylim([-0.4 0.8])
str = sprintf('Developing Mouse over all time points');
title(str,'FontSize', 19);
hold on

% Plot the global bins
theStyle = '-';
theLineWidth = 2;
theColor='b';
xData=distanceGlobal;
yData=corrCoeffGlobal;
numThresholds = 10;
xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
xThresholds(end) = xThresholds(end) + eps;
yMeans = arrayfun(@(x)mean(yData(xData>=xThresholds(x) & xData < xThresholds(x+1))),1:numThresholds-1);

xPlotData=zeros(numThresholds-1,1);
yPlotData=zeros(numThresholds-1,1);
for g = 1:numThresholds-1
    %plot(xThresholds(g:g+1),ones(2,1)*yMeans(g),'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
    xPlotData(g)=mean(xThresholds(g:g+1));
    yPlotData(g)=yMeans(g);
    hold on
end

plot(xPlotData,yPlotData,'-o','MarkerSize',5,'LineStyle',theStyle,'LineWidth',theLineWidth,'Color',theColor)
    
%% [Binning] Binning of all time points together in same graph, all dots are coloured
% first, get the colours needed
cmapOut = BF_getcmap('dark2',7,0,0);
%% second, plot data from different time points in quantiles in the same graph 
% plot coexpression against distance for each of the 7 time points, and fitting

%b=figure('color','w');
for i=1:7 % plot P28 first so that it does not cover other dots
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

 
    %divisions=dataDevMouse.(timePoints{i}).division(colorIndex); % division follows the fill colour (for the time being)
    % check if number of corrCoeff is same as distance
    if length(corrCoeff)~=length(distance)
        %error('number of correlations not equal to number of distances, graph cannot be plotted')
        continue
    end


    % filter off data points with no coexpression data available
    isMissing_coexpress=isnan(corrCoeff);
    corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
    distance_clean=distance(~isMissing_coexpress);
    
    %divisions_clean=divisions(~isMissing_coexpress);
     %Plot correlation against distance

    %match colors
    
    %numRegions=length(distance_clean);
    
    % plot in bins, each time only 1 timepoint is coloured
    s=figure('color','w','units','normalized','outerposition',[0 0 1 1]);
    
    BF_PlotQuantiles_diffColor(distance_clean,corrCoeff_clean,20,0,cmapOut(i,:),0);

    
    hold on
    ylim([-0.4 0.8])
    yPosition=linspace(1,0.4,length(timePoints));
    t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
            cmapOut(i,:));
    t.Units='normalized';
    t.Position=[1 yPosition(i)];
    str=sprintf('Developing Mouse %s binning with threshold number=20',timePoints{i});
    title(str,'Fontsize',18)
    hold on
    
    nodeSize = 10;
    s=scatter(distance_clean,corrCoeff_clean,nodeSize,cmapOut(i,:),'LineWidth',0.3);
    set(s,'Marker','.')
    hold on

    %scatter(distance_clean,corrCoeff_clean,nodeSize,dotColors_use,'filled','MarkerEdgeColor','k','LineWidth',0.5)
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
    xlim([0 9000]) 
end


%%
% % Below are just some drafts, not implemented (DO NOT DELETE)

%%
%     % fit an exponential
%     x=distance_clean;
%     y=corrCoeff_clean;
%     f = fit(x,y,'exp1');
%     plot(f,x,y)
%     str = sprintf('Developing Mouse %s',currentTimePoint);
%     xlabel('Separation Distance (um)')
%     ylabel('Gene Coexpression (correlation coefficient)')
%     title(str);

%     % fit 2 term exponential
%     f=figure('color','w');
%     x=distance_clean;
%     y=corrCoeff_clean;
%     f2 = fit(x,y,'exp2');
%     plot(f2,x,y)
%     str = sprintf('Developing Mouse %s, 2 term exponential',currentTimePoint);
%     xlabel('Separation Distance (um)','FontSize', 16)
%     ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
%     xlim([0 9000])
%     title(str,'FontSize',19);
%     file_name=sprintf('GeneCoexpress_%s_2TermExpo.jpg',currentTimePoint);
%     cd 'D:\Data\DevelopingAllenMouseAPI-master\Figures\DevMouse_Level5_GeneCoexpression\2TermExponential'
%     saveas(gcf,file_name)
    
    
%     %retain the residuals
%      fitCoeff=coeffvalues(f2);
%      residualCorr{i}=zeros(length(distance_clean),1);
%      for k=1:length(distance_clean)
%          residualCorr{i}(k)=corrCoeff_clean(k)-fitCoeff(1)*exp(fitCoeff(2)*corrCoeff_clean(k));
%      end
%      
%     % rank regions pairs based on magnitude of gene coexpression after spatial correction
%     regionPairs{i}=cell(length(distance_clean),1); % create empty cell array of region pairs for current time point
%     % create acronym cell array for ease of coding
%     acronymCell=cell(length(ib),length(ib));
%     acronym_relevant=dataDevMouse.(timePoints{i}).acronym(ib);
%     for h=1:length(ib) % cell row
%         for d=1:length(ib) % cell column
%             acronymCell{h,d}={acronym_relevant{h},acronym_relevant{d}}; % each cell entry is a label pair
%         end
%     end
%     % extract the needed acronym pairs
%     acronymPair={};
%     for j=2:size(acronymCell,2)
%         acronymPair=vertcat(acronymPair,acronymCell(1:(j-1),j));
%     end
%     % sorting label pairs according to magnitude of spatially-corrected gene coexpression
%     [~,ix] = sort(residualCorr{i},'descend');
%     acronymCell_sort{i}=acronymPair(ix);


% 
% end
% %%
% 
% %% troubleshooting
% for i=7:7 % for each time point
%     slice=squeeze(gene3D(i,:,:))'; % makes a matrix of 78 (structure) x 2100 (genes)
%     % filter off structures with more than 10% of genes missing
%     isMissing=(sum(~isnan(slice),2) <= 0.1*length(geneList));
%     slice_clean=slice(~isMissing,:);
%     % match the structure regions (because not all time points have all region coordinates available)
%     [~,ia,ib]=intersect(char(structures(~isMissing)),dataDevMouse.(timePoints{i}).acronym,'stable');
%     % only structures in which coordinates are available are used
%     slice_clean=slice_clean(ia,:);
%     % compute correlation coefficient between region pairs
%     geneCorr{i} = corrcoef(slice_clean','rows','pairwise');
%     % extract the correlation coefficients
%     %corrCoeff=geneCorr{i}(isnan(triu(geneCorr{i},1)) | triu(geneCorr{i},1) ==0 |triu(geneCorr{i},1) ~=0); % extract the correlation coefficients
%     corrCoeff=[];
%     for j=2:size(geneCorr{i},2)
%         corrCoeff=[corrCoeff;geneCorr{i}(1:(j-1),j)];
%     end
%     % extract the distances needed
%     distanceMat=dataDevMouse.(timePoints{i}).distance(ib,ib);
%     distance=distanceMat(find(triu(distanceMat,1)));
%     % check if number of corrCoeff is same as distance
%     if length(corrCoeff)~=length(distance)
%         error('number of correlations not equal to number of distances, graph cannot be plotted')
%     else
%         continue
%     end
% end
% %% filter off data points with no coexpression data available
% isMissing_coexpress=isnan(corrCoeff);
% corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
% distance_clean=distance(~isMissing_coexpress);
% %%
%     %  Plot correlation against distance
%     g=figure('color','w');
%     scatter(distance_clean,corrCoeff_clean)
%     xlabel('Separation Distance (um)')
%     ylabel('Gene Coexpression')
%     currentTimePoint=timePoints{i};
%     str = sprintf('Developing Mouse %s',currentTimePoint);
%     %%
%     % fit an exponential
%     x=distance_clean;
%     y=corrCoeff_clean;
%     f = fit(x,y,'exp1');
%     plot(f,x,y)
%     %%
%     %retain the residuals
%     fitCoeff=coeffvalues(f);
%     residualCorr{i}=zeros(length(distance_clean),1);
%     for k=1:length(distance_clean)
%         residualCorr{i}(k)=corrCoeff_clean(k)-fitCoeff(1)*exp(fitCoeff(2)*corrCoeff_clean(k));
%     end
%     %%
%     % rank regions pairs based on magnitude of gene coexpression after spatial correction
%     regionPairs{i}=cell(length(distance_clean),1); % create empty cell array of region pairs for current time point
%     % create acronym cell array for ease of coding
%     acronymCell=cell(length(distance_clean),length(distance_clean));
%     acronym_relevant=dataDevMouse.(timePoints{i}).acronym(ib);
%     for h=1:length(distance_clean) % cell row
%         for d=1:length(distance_clean) % cell column
%             acronymCell{h,d}={acronym_relevant{h},acronym_relevant{d}}; % each cell entry is a label pair
%         end
%     end
%     %%
%     % sorting label pairs according to magnitude of spatially-corrected gene coexpression
%     [~,ix] = sort(residualCorr{i},'descend') ;
%     acronymCell_sort{i}=acronymCell([ix]);
%  
% %%
% corrCoeff=[];
%     for j=2:size(geneCorr{i},2)
%         corrCoeff=[corrCoeff;geneCorr{i}(1:(j-1),j)];
%     end

% %%
% save('DevMouseGeneExpression.mat','structures','Exp','geneEntrez','geneList','timePoints')

