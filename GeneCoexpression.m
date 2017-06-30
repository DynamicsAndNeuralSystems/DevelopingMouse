
%%
load('DevMouseGeneExpression.mat')
load('dataDevMouse.mat')
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
fitMethods={'linear','exp','exp_1_0','exp1'};
globalMeasure=1;

%-------------------------------------------------------------------------------
%%  initial conditions
%-------------------------------------------------------------------------------
% specify 7 time points [globalMeasure=0] or all as one (global) [globalMeasure=1]
geneCorr=cell(length(timePoints),1);
residualCorr=cell(length(timePoints),1);
regionPairs=cell(length(timePoints),1);
acronymCell_sort=cell(length(timePoints),1);
% for fitting
adjRSquare=struct();
confInt=struct();
coeffValue=struct();
adjRSquare_global=struct();
confInt_global=struct();
coeffValue_global=struct();
for j=1:length(fitMethods)
    adjRSquare.(fitMethods{j})=cell(length(timePoints),1);
    confInt.(fitMethods{j})=cell(length(timePoints),1);
    coeffValue.(fitMethods{j})=cell(length(timePoints),1);
    adjRSquare_global.(fitMethods{j})=cell(1,1);
    confInt_global.(fitMethods{j})=cell(1,1);
    coeffValue_global.(fitMethods{j})=cell(1,1);
end

gene3D=MakeMatrix(Exp.Energy.norm);

%% plot global coexpression against distance
symbol={'o','^','<','v','^','square','diamond'};
% make empty matrices to store the distances and correlations
distanceGlobal=[];
corrCoeffGlobal=[];
f=figure('color','w'); hold on
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
    dataDevMouse.(timePoints{i}).color=dataDevMouse.(timePoints{i}).color(ib,:);
    colorIndex=zeros(length(distance),1);
    edgeColorIndex=zeros(length(distance),1);
    for j=1:length(distance) % find indices of extracted entries in the distance matrix
        [iq,ir]=ind2sub4up(j);
        colorIndex(j)=iq;
        edgeColorIndex(j)=ir;
    end
    dotColors=dataDevMouse.(timePoints{i}).color(colorIndex);
    edgeColors=dataDevMouse.(timePoints{i}).color(edgeColorIndex);

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
    dotColors_clean=dotColors(~isMissing_coexpress);
    edgeColors_clean=edgeColors(~isMissing_coexpress);
    if i==1
        distanceGlobal=distance_clean;
        corrCoeffGlobal=corrCoeff_clean;
    else
        distanceGlobal=vertcat(distanceGlobal,distance_clean);
        corrCoeffGlobal=vertcat(corrCoeffGlobal,corrCoeff_clean);
    end
    %divisions_clean=divisions(~isMissing_coexpress);
    %  Plot correlation against distance

    % match colors

    numRegions=length(distance_clean);

    dotColors_use = arrayfun(@(x) rgbconv(dotColors_clean{x})',...
                                        1:numRegions,'UniformOutput',0);
    dotColors_use = [dotColors_use{:}]';

    edgeColors_use = arrayfun(@(x) rgbconv(edgeColors_clean{x})',...
                                        1:numRegions,'UniformOutput',0);
    edgeColors_use = [edgeColors_use{:}]';

    divisionColor= arrayfun(@(x) rgbconv(dataDevMouse.(timePoints{i}).division_color{x})',...
        1:length(dataDevMouse.(timePoints{i}).division_color),'UniformOutput',0);
    divisionColor=[divisionColor{:}]';

    nodeSize = 50;
%     g=figure('color','w');
    %symbol='diamond';
    for k=1:length(distance_clean) % plot the dots one by one
        f=scatter(distance_clean(k),corrCoeff_clean(k),nodeSize,dotColors_use(k,:),symbol{i},'filled','MarkerEdgeColor',...
            edgeColors_use(k,:),'LineWidth',2);
        hold on
    end

    %scatter(distance_clean,corrCoeff_clean,nodeSize,dotColors_use,'filled','MarkerEdgeColor','k','LineWidth',0.5)
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
    xlim([0 9000])
    % add major division color legends
    divisionLabels = categorical(dataDevMouse.(timePoints{i}).division);
    theDivisions = unique(divisionLabels);
    numDivisions = length(theDivisions);
    yPosition=linspace(1,0,numDivisions);
    for j = 1:numDivisions
        find_1 = find(divisionLabels==theDivisions(j),1); % find an index of the correct color
        %text(char(theDivisions(i)),'color','k','FontSize',14,'BackgroundColor',dotColors_use(find_1,:))
        %t=textLoc(char(theDivisions(j)),'NorthEast','color','k','FontSize',14,'BackgroundColor',dotColors_use(find_1,:));
        t=text(0.5,0.5,char(theDivisions(j)),'color','k','FontSize',14,'BackgroundColor',...
            divisionColor(find_1,:));
        t.Units='normalized';
        t.Position=[1 yPosition(j)];
    end

     str = sprintf('Developing Mouse over all time points');
     title(str,'FontSize',19);
end
hold off

%% fitting for global
for j=1:length(fitMethods)
    [~,Stats,c] = GiveMeFit(distanceGlobal,corrCoeffGlobal,fitMethods{j},true);
    adjRSquare_global.(fitMethods{j})=Stats.adjrsquare;
    confInt_global.(fitMethods{j})=confint(c,0.95);
    coeffValue_global.(fitMethods{j})=coeffvalues(c);
end
%% save global fitting info
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
save('confInt_global.mat','confInt_global')
save('adjRSquare_global.mat','adjRSquare_global')
save('coeffValue_global.mat','coeffValue_global')

%% plot coexpression against distance for each of the 7 time points, and fitting
load('dataDevMouse.mat')
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
    dataDevMouse.(timePoints{i}).color=dataDevMouse.(timePoints{i}).color(ib,:);
    colorIndex=zeros(length(distance),1);
    edgeColorIndex=zeros(length(distance),1);


    for j=1:length(distance) % find indices of extracted entries in the distance matrix
        [iq,ir]=ind2sub4up(j);
        colorIndex(j)=iq;
        edgeColorIndex(j)=ir;
    end
    dotColors=dataDevMouse.(timePoints{i}).color(colorIndex);
    edgeColors=dataDevMouse.(timePoints{i}).color(edgeColorIndex);

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
    dotColors_clean=dotColors(~isMissing_coexpress);
    edgeColors_clean=edgeColors(~isMissing_coexpress);
    %divisions_clean=divisions(~isMissing_coexpress);
    %  Plot correlation against distance

    g=figure('color','w');
    % match colors

    numRegions=length(distance_clean);

    dotColors_use = arrayfun(@(x) rgbconv(dotColors_clean{x})',...
                                        1:numRegions,'UniformOutput',0);
    dotColors_use = [dotColors_use{:}]';

    edgeColors_use = arrayfun(@(x) rgbconv(edgeColors_clean{x})',...
                                        1:numRegions,'UniformOutput',0);
    edgeColors_use = [edgeColors_use{:}]';

    divisionColor= arrayfun(@(x) rgbconv(dataDevMouse.(timePoints{i}).division_color{x})',...
        1:length(dataDevMouse.(timePoints{i}).division_color),'UniformOutput',0);
    divisionColor=[divisionColor{:}]';

    nodeSize = 50;
    for k=1:length(distance_clean) % plot the dots one by one
        scatter(distance_clean(k),corrCoeff_clean(k),nodeSize,dotColors_use(k,:),'filled','MarkerEdgeColor',...
            edgeColors_use(k,:),'LineWidth',2)
        hold on
    end

    %scatter(distance_clean,corrCoeff_clean,nodeSize,dotColors_use,'filled','MarkerEdgeColor','k','LineWidth',0.5)
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
    xlim([0 9000])
    str = sprintf('Developing Mouse %s',timePoints{i});
    title(str,'Fontsize',19);

    % add major division color legends
    divisionLabels = categorical(dataDevMouse.(timePoints{i}).division);
    theDivisions = unique(divisionLabels);
    numDivisions = length(theDivisions);
    yPosition=linspace(1,0,numDivisions);
    for j = 1:numDivisions
        find_1 = find(divisionLabels==theDivisions(j),1); % find an index of the correct color
        %text(char(theDivisions(i)),'color','k','FontSize',14,'BackgroundColor',dotColors_use(find_1,:))
        %t=textLoc(char(theDivisions(j)),'NorthEast','color','k','FontSize',14,'BackgroundColor',dotColors_use(find_1,:));
        t=text(0.5,0.5,char(theDivisions(j)),'color','k','FontSize',14,'BackgroundColor',...
            divisionColor(find_1,:));
        t.Units='normalized';
        t.Position=[1 yPosition(j)];
    end

    % fitting
    for j=1:length(fitMethods)
        [~,Stats,c] = GiveMeFit(distance_clean,corrCoeff_clean,fitMethods{j},true);
        adjRSquare.(fitMethods{j}){i}=Stats.adjrsquare;
        confInt.(fitMethods{j}){i}=confint(c,0.95);
        coeffValue.(fitMethods{j}){i}=coeffvalues(c);
    end
end

%% save fitting info for the 7 time points
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
save('confInt.mat','confInt')
save('adjRSquare.mat','adjRSquare')
save('coeffValue.mat','coeffValue')


%% plot the Degrees of Freedom Adjusted R-Square in different time points, including global
fitMethods={'linear','exp_1_0','exp1','exp',};
matAdjRSquare=zeros(length(timePoints)+1,length(fitMethods)); % +1 because of global

for i=1:length(timePoints)
    for j=1:length(fitMethods)
        matAdjRSquare(i,j)=adjRSquare.(fitMethods{j}){i};
    end
end
% add in global
for j=1:length(fitMethods)
    matAdjRSquare(length(timePoints)+1,j)=adjRSquare_global.(fitMethods{j});
end

g=figure('color','w');
xAxis=[1:length(timePoints)+1];
BarChart=bar(xAxis,matAdjRSquare);
BarChat.BarWidth = 0.7;
ax = gca;
ax.XTick=[1 2 3 4 5 6 7 8];
ax.XTickLabel={'E11.5','E13.5','E15.5','E18.5','P4','P14','P28','Global'};
xt=[1 2 3 4 5 6 7 8];
Title=title('Degree of freedom adjusted R-square');
set(Title, 'FontSize', 16)

L = cell(1,4);
L{1}='linear';
L{2}='1 parameter exponential';
L{3}='2 parameter exponential';
L{4}='3 parameter exponential';
legend(BarChart,L,'Location','southwest')
hold on

xPosition=linspace(-0.3,0.3,4);
for i=1:length(timePoints)+1
    for j=1:4 % for each fitting method
        t=text(xt(i)+xPosition(j),matAdjRSquare(i,j),num2str(round(matAdjRSquare(i,j),2)),'HorizontalAlignment','center',...
        'VerticalAlignment','bottom');
        t.Units='normalized';
        t.FontSize=8;
    end
end

%-------------------------------------------------------------------------------
%% Plotting each fitting parameter with their confidence intervals , including global
%-------------------------------------------------------------------------------

negCell=cell(length(fitMethods),1);
posCell=cell(length(fitMethods),1);
for j=1:length(fitMethods)
    negCell{j}=cell(length(timePoints)+1,1); % +1 to include global
    posCell{j}=cell(length(timePoints)+1,1);
    for i=1:length(timePoints)
        negCell{j}{i}=coeffValue.(fitMethods{j}){i}-confInt.(fitMethods{j}){i}(2,:);
        posCell{j}{i}=confInt.(fitMethods{j}){i}(1,:)-coeffValue.(fitMethods{j}){i};
    end
    negCell{j}{8}=coeffValue_global.(fitMethods{j})-confInt_global.(fitMethods{j})(2,:);
    posCell{j}{8}=confInt_global.(fitMethods{j})(1,:)-coeffValue_global.(fitMethods{j});
end
%%
matCoeffValue=cell(length(fitMethods),1);
matUpConfInt=cell(length(fitMethods),1);
matDownConfInt=cell(length(fitMethods),1);

%%
for j=1:length(fitMethods)
    for i=1:length(timePoints) % +1 for global
        matCoeffValue{j}=zeros(length(timePoints)+1,length(coeffValue.(fitMethods{j}){i})+1);
        matUpConfInt{j}=zeros(length(timePoints)+1,length(coeffValue.(fitMethods{j}){i})+1);
        matDownConfInt{j}=zeros(length(timePoints)+1,length(coeffValue.(fitMethods{j}){i})+1);
    end
end

%-------------------------------------------------------------------------------
%%
for j=1:length(fitMethods)
    for i=1:length(timePoints)
        for k=1:length(coeffValue.(fitMethods{j}){i})
            matCoeffValue{j}(i,k)=coeffValue.(fitMethods{j}){i}(k); % some problem, continue tmr
            matUpConfInt{j}(i,k)=confInt.(fitMethods{j}){i}(1,k);
            matDownConfInt{j}(i,k)=confInt.(fitMethods{j}){i}(2,k);
            %bar([1:7],matCoeffValue(i,j)); % some problem, need to move
            %this chunk into outermost loop
            matCoeffValue{j}(8,k)=coeffValue_global.(fitMethods{j})(k); % some problem, continue tmr
            matUpConfInt{j}(8,k)=confInt_global.(fitMethods{j})(1,k);
            matDownConfInt{j}(8,k)=confInt_global.(fitMethods{j})(2,k);
        end
    end


    f=figure('color','w');
    hBar=bar(1:length(timePoints)+1,matCoeffValue{j});
    set(gca, 'XTickLabel', {'E11.5','E13.5','E15.5','E18.5','P4','P14','P28','Global'})
    xlabel('Developmental time points')
    ylabel('Fitting parameter(s) value(s)')
%     hold on
% %
% %     ofst = get(hBar,'XOffset');
%     for k1 = 1:size(matCoeffValue{j},2)
%         ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
%         ydt(k1,:) = hBar(k1).YData;
%     end
%
%     hold on
%     errorbar(1:length(timePoints),matCoeffValue{j},matCoeffValue{j}-matDownConfInt{j},...
%          matUpConfInt{j}-matCoeffValue{j});
%     errorbar(ctr, ydt,2,2)
    % matCoeffValue{j}-matDownConfInt{j},matUpConfInt{j}-matCoeffValue{j},
    %,matCoeffValue-matDownConfInt,matUpConfInt-matCoeffValue
    string=sprintf('Parameter with confidence intervals of fitting with %s',fitMethods{j});
    title(string)
    hold on
    xt=1:8;

    for i=1:length(timePoints)+1
        for k=1:length(coeffValue.(fitMethods{j}){1})
            xPosition=linspace(-0.08*length(coeffValue.(fitMethods{j}){1}),0.08*length(coeffValue.(fitMethods{j}){1}),...
                length(coeffValue.(fitMethods{j}){1}));
            t=text(xt(i)+xPosition(k),matCoeffValue{j}(i,k),num2str(round(matCoeffValue{j}(i,k),3)),'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
            t.Units='normalized';
            t.FontSize=8;
%             % set things for global separately
%             xPosition=linspace(-0.3,0.3,length(coeffValue.(fitMethods{j}){1}));
%             t=text(xt(i)+xPosition(k),matCoeffValue{j}(i,k),num2str(round(matCoeffValue{j}(i,k),3)),'HorizontalAlignment','center',...
%             'VerticalAlignment','bottom');
%             t.Units='normalized';
%             t.FontSize=8;

        end
    end
    hold on
    % add error bars with a loop through all parameters in a fitting method
    xPosition=linspace(-0.09*length(coeffValue.(fitMethods{j}){1}),0.09*length(coeffValue.(fitMethods{j}){1}),...
        length(coeffValue.(fitMethods{j}){1}));
    for i=1:length(timePoints)+1
        for k=1:length(coeffValue.(fitMethods{j}){1}) % for each parameter
            errorbar(xt(i)+xPosition(k),matCoeffValue{j}(i,k),matCoeffValue{j}(i,k)-matDownConfInt{j}(i,k),...
          matUpConfInt{j}(i,k)-matCoeffValue{j}(i,k))
        hold on
        end
    hold on
    end
end

%%
% % Below are just some drafts, not implemented (DO NOT DELETE)
%%
% %% convert the acronymCell_sort into a structure of tables
% coexpressAcronym=struct();
% timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% for i=1:length(timePoints)
%     coexpressAcronym.(timePoints{i})=cell2table(acronymCell_sort{i});
% end
% %% save the coexpress Acronym
% cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
% save('coexpressAcronym.mat','coexpressAcronym')
% %% save the coexpress Acronym as csv file
% cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
% for i=1:length(timePoints)
%     currentTimePoint=timePoints{i};
%     tableFileName=sprintf('coExpressAcronym_%s.csv',currentTimePoint);
%     writetable(coexpressAcronym.(timePoints{i}),tableFileName)
% end

%% experimentation (half done)
% [GOTable,geneEntrezAnnotations] = GetFilteredGOData('biological_process',[5,200],geneEntrez);
% % import GO ID related to CNS
% cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables\Others'
% goCatID=xlsread('GO_CNS_related.xlsx',1,'B2:B235');
% isRelated=ismember(GOTable.GOID,goCatID);
% %%
% geneEntrezAnnotationsRelated=geneEntrezAnnotations(isRelated);
% geneEntrezRelated=cell(length(geneEntrezAnnotationsRelated),1); % for each GO group, there are a number of genes
% for i=1:length(geneEntrezAnnotationsRelated)
%     geneEntrezRelated{i}=geneEntrez(ismember(geneEntrez,geneEntrezAnnotationsRelated{i}));
% end
% %%
% % average expression level of each GO group of geneEntrez in each time point
% geneCount=cell(length(timePoints),1);
% geneSlice=cell(length(timePoints),1);
% geneEntrezRelated_clean=cell(length(timePoints),1);
% for i=1:length(timePoints)
%     geneEntrezRelated_clean{i}=geneEntrezRelated; % before filtering, each time point originally full set
%     %of GO categories with full set of genes in each category
%     for j=1:length(geneEntrezRelated) % for each GO group, count number of available gene
%         geneSlice{i}{j}=cell(length(geneEntrezRelated{j}),1);
%         geneCount{i}{j}=zeros(1,1);
%         for k=1:length(geneEntrezRelated{i})  % for each gene in that GO group (count genes)
%             geneSlice{i}{j}{k}=squeeze(gene3D(:,find(geneEntrezRelated{i}(j)(k)==geneEntrez),:))'; % 78 structures x 7 time points
%             % check that at least 1 gene is available in each GO group
%             % in each gene: only keep structures that have at least half of all structures with data in each
%             %time point
%             isMissing_timePoint=sum(isnan(geneSlice{i}{j}{k}))>(0.5*length(structures));
%             if nnz(isMissing_timePoint)==length(timePoints) % if no time point available, gene not counted
%                 continue
%             end
%             geneCount{i}{j}=geneCount{i}{j}+1;
%         end % if a GO category has no gene available, it is discarded
%         if geneCount{i}{j}==0
%             isMissing_GO
%             geneEntrezRelated_clean{i}=geneEntrezRelated_clean{i};
%
%     end
%     end
% end
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
