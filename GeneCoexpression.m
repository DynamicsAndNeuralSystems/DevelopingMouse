
%%
load('DevMouseGeneExpression.mat')
load('dataDevMouse.mat')

%%  initial conditions
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
geneCorr=cell(length(timePoints),1);
residualCorr=cell(length(timePoints),1);
regionPairs=cell(length(timePoints),1);
acronymCell_sort=cell(length(timePoints),1);

gene3D=MakeMatrix(Exp.Energy.norm);
%%
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
    currentTimePoint=timePoints{i};
    str = sprintf('Developing Mouse %s',currentTimePoint);
    title(str,'FontSize', 19);
%     % fit an exponential
%     x=distance_clean;
%     y=corrCoeff_clean;
%     f = fit(x,y,'exp1');
%     plot(f,x,y)
%     str = sprintf('Developing Mouse %s',currentTimePoint);
%     xlabel('Separation Distance (um)')
%     ylabel('Gene Coexpression (correlation coefficient)')
%     title(str);

    % fit 2 term exponential
    f=figure('color','w');
    x=distance_clean;
    y=corrCoeff_clean;
    f2 = fit(x,y,'exp2');
    plot(f2,x,y)
    str = sprintf('Developing Mouse %s, 2 term exponential',currentTimePoint);
    xlabel('Separation Distance (um)','FontSize', 16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
    xlim([0 9000])
    title(str,'FontSize',19);
    file_name=sprintf('GeneCoexpress_%s_2TermExpo.jpg',currentTimePoint);
    cd 'D:\Data\DevelopingAllenMouseAPI-master\Figures\DevMouse_Level5_GeneCoexpression\2TermExponential'
    saveas(gcf,file_name)
    
    
    
    
    
    %retain the residuals
     fitCoeff=coeffvalues(f2);
     residualCorr{i}=zeros(length(distance_clean),1);
     for k=1:length(distance_clean)
         residualCorr{i}(k)=corrCoeff_clean(k)-fitCoeff(1)*exp(fitCoeff(2)*corrCoeff_clean(k));
     end
     
    % rank regions pairs based on magnitude of gene coexpression after spatial correction
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
    acronymPair={};
    for j=2:size(acronymCell,2)
        acronymPair=vertcat(acronymPair,acronymCell(1:(j-1),j));
    end
    % sorting label pairs according to magnitude of spatially-corrected gene coexpression
    [~,ix] = sort(residualCorr{i},'descend');
    acronymCell_sort{i}=acronymPair(ix);
    
end
%% convert the acronymCell_sort into a structure of tables
coexpressAcronym=struct();
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
for i=1:length(timePoints)
    coexpressAcronym.(timePoints{i})=cell2table(acronymCell_sort{i});
end
%% save the coexpress Acronym
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
save('coexpressAcronym.mat','coexpressAcronym')
%% save the coexpress Acronym as csv file
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
for i=1:length(timePoints) 
    currentTimePoint=timePoints{i};
    tableFileName=sprintf('coExpressAcronym_%s.csv',currentTimePoint);
    writetable(coexpressAcronym.(timePoints{i}),tableFileName)
end
%% experimentation (half done)
[GOTable,geneEntrezAnnotations] = GetFilteredGOData('biological_process',[5,200],geneEntrez);
% import GO ID related to CNS
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables\Others'
goCatID=xlsread('GO_CNS_related.xlsx',1,'B2:B235');
isRelated=ismember(GOTable.GOID,goCatID);
%%
geneEntrezAnnotationsRelated=geneEntrezAnnotations(isRelated);
geneEntrezRelated=cell(length(geneEntrezAnnotationsRelated),1); % for each GO group, there are a number of genes
for i=1:length(geneEntrezAnnotationsRelated)
    geneEntrezRelated{i}=geneEntrez(ismember(geneEntrez,geneEntrezAnnotationsRelated{i}));
end
%%
% average expression level of each GO group of geneEntrez in each time point
geneCount=cell(length(timePoints),1);
geneSlice=cell(length(timePoints),1);
geneEntrezRelated_clean=cell(length(timePoints),1);
for i=1:length(timePoints)
    geneEntrezRelated_clean{i}=geneEntrezRelated; % before filtering, each time point originally full set 
    %of GO categories with full set of genes in each category
    for j=1:length(geneEntrezRelated) % for each GO group, count number of available gene
        geneSlice{i}{j}=cell(length(geneEntrezRelated{j}),1);
        geneCount{i}{j}=zeros(1,1);
        for k=1:length(geneEntrezRelated{i})  % for each gene in that GO group (count genes)
            geneSlice{i}{j}{k}=squeeze(gene3D(:,find(geneEntrezRelated{i}(j)(k)==geneEntrez),:))'; % 78 structures x 7 time points
            % check that at least 1 gene is available in each GO group
            % in each gene: only keep structures that have at least half of all structures with data in each
            %time point
            isMissing_timePoint=sum(isnan(geneSlice{i}{j}{k}))>(0.5*length(structures));
            if nnz(isMissing_timePoint)==length(timePoints) % if no time point available, gene not counted
                continue
            end
            geneCount{i}{j}=geneCount{i}{j}+1; 
        end % if a GO category has no gene available, it is discarded
        if geneCount{i}{j}==0
            isMissing_GO
            geneEntrezRelated_clean{i}=geneEntrezRelated_clean{i};
          
    end
        
            
                
           

    

    end
end

%%
% % Below are just some drafts, not implemented
adjRSquare_linear=cell(length(timePoints),1);
adjRSquare_exp_1_0=cell(length(timePoints),1);
adjRSquare_exp1=cell(length(timePoints),1);
adjRSquare_exp=cell(length(timePoints),1);
% fitting 
    [~,~,c] = GiveMeFit(distance_clean,corrCoeff_clean,linear,true);
    adjRSquare_linear{i}=c.adjrsquare;
    [~,~,c] = GiveMeFit(distance_clean,corrCoeff_clean,exp_1_0,true);
    adjRSquare_exp_1_0{i}=c.adjrsquare;
    [~,~,c] = GiveMeFit(distance_clean,corrCoeff_clean,exp1,true);
    adjRSquare_exp1{i}=c.adjrsquare;
    [~,~,c] = GiveMeFit(distance_clean,corrCoeff_clean,exp,true);
    adjRSquare_exp{i}=c.adjrsquare;

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