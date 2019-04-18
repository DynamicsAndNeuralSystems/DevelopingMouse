clearvars
% user input: the
whichField={'normStructure'};
% user input: the percentage of genes missing above which to filter a structure
filterThreshold = 0.1;
% load variables
load('dataDevMouse.mat')
load('DevMouseGeneExpression.mat')

% create time(7) x 2100 (genes) x 78 (structure) matrix
gene3D=MakeMatrix(Exp.Energy.(whichField{1}));

% Initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
geneCorr=cell(length(timePoints),1);
% for later plotting
symbol={'o','^','<','v','^','square','diamond'};
% make empty matrices to store the distances and correlations
% distanceGlobal=[];
% corrCoeffGlobal=[];

for i=1%1:length(timePoints) % for each time point
    slice=squeeze(gene3D(i,:,:)); % makes a matrix of 78 (structure) x 2100 (genes)
    % filter off structures with more than 10% of genes missing
    isMissing=(sum(~isnan(slice),2) <= filterThreshold*length(geneList));
    slice_clean=slice(~isMissing,:);
    % match the structure regions (because not all time points have all region coordinates available)
    [~,ia,ib]=intersect(char(structures(~isMissing)),dataDevMouse.(timePoints{i}).acronym,'stable');
    % only structures in which coordinates are available are used
    slice_clean=slice_clean(ia,:);
    % compute correlation coefficient between region pairs
    geneCorr{i} = corrcoef('slice_clean','rows','pairwise');
    % extract the correlation coefficients
    corrCoeff=[];
    for j=2:size(geneCorr{i},2)
        corrCoeff=[corrCoeff;geneCorr{i}(1:(j-1),j)];
    end
    % extract the distances needed
    distanceMat=dataDevMouse.(timePoints{i}).distance(ib,ib);
    distances=computeDistances(distanceMat);
    % extract the colours needed
    dataDevMouse.(timePoints{i}).color=dataDevMouse.(timePoints{i}).color(ib,:);
    colorIndex=zeros(length(distances),1);
    edgeColorIndex=zeros(length(distances),1);
    for j=1:length(distances) % find indices of extracted entries in the distance matrix
        [iq,ir]=ind2sub4up(j);
        colorIndex(j)=iq;
        edgeColorIndex(j)=ir;
    end
    dotColors=dataDevMouse.(timePoints{i}).color(colorIndex);
    edgeColors=dataDevMouse.(timePoints{i}).color(edgeColorIndex);

    %divisions=dataDevMouse.(timePoints{i}).division(colorIndex); % division follows the fill colour (for the time being)
    % check if number of corrCoeff is same as distance
    % if length(corrCoeff)~=length(distance)
    %     %error('number of correlations not equal to number of distances, graph cannot be plotted')
    %     continue
    % end
    % filter off data points with no coexpression data available
    isMissing_coexpress=isnan(corrCoeff);
    corrCoeff_clean=(corrCoeff(~isMissing_coexpress));
    distances_clean=distances(~isMissing_coexpress);
    dotColors_clean=dotColors(~isMissing_coexpress);
    edgeColors_clean=edgeColors(~isMissing_coexpress);
    % if i==1
    %     distanceGlobal=distance_clean;
    %     corrCoeffGlobal=corrCoeff_clean;
    % else
    %     distanceGlobal=vertcat(distanceGlobal,distance_clean);
    %     corrCoeffGlobal=vertcat(corrCoeffGlobal,corrCoeff_clean);
    % end
    %divisions_clean=divisions(~isMissing_coexpress);
    %  Plot correlation against distance

    % match colors
    numRegions=length(distances_clean);

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
    g=figure('color','w');
    %symbol='diamond';
    for k=1:length(distances_clean) % plot the dots one by one
        f=scatter(distances_clean(k),corrCoeff_clean(k),nodeSize,dotColors_use(k,:),symbol{i},'filled','MarkerEdgeColor',...
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

     % save figure
     filename = strcat('GeneCoexpression_scatter','_', timePoints{i},'.jpeg');
     str = fullfile('Outs','gene_coexpression_scatter');
     saveas(g,str)
end
