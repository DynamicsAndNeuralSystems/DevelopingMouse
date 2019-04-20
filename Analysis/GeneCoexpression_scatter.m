clearvars
% user input: the
whichField={'normStructure'};
% user input: the percentage of genes missing above which to filter a structure
filterThreshold = 0.9;
% load variables
load('dataDevMouse.mat')
load('DevMouseGeneExpression.mat')
[acronym,acronymPath]=importfile_AcronymPath_level5('AcronymPath_level5.csv')
% create time(7) x 2100 (genes) x 78 (structure) matrix
gene3D=MakeMatrix(Exp.Energy.(whichField{1}));

% Initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
geneCorr=cell(length(timePoints),1);
distances_clean=cell(length(timePoints),1);
corrCoeff_clean=cell(length(timePoints),1);
ontoDist_clean=cell(length(timePoints),1);
% for later plotting
symbol={'o','^','<','v','^','square','diamond'};
% make empty matrices to store the distances and correlations
% distanceGlobal=[];
% corrCoeffGlobal=[];

for i=1:length(timePoints) % for each time point
    slice=squeeze(gene3D(i,:,:)); % makes a matrix of 78 (structure) x 2100 (genes)
    % filter off structures with more than a certain threshold % of genes missing
    isMissing=((sum(isnan(slice),1)) >= (filterThreshold*length(geneList)));
    slice_clean=slice(:,~isMissing);
    % match the structure regions (because not all time points have all region coordinates available)
    [~,ia,ib]=intersect(char(structures(~isMissing)),dataDevMouse.(timePoints{i}).acronym,'stable');
    [~,ix,iy]=intersect(char(structures(~isMissing)),acronym,'stable');
    % only structures in which coordinates are available are used
    slice_clean=slice_clean(:,ia);
    % compute correlation coefficient between region pairs
    geneCorr{i} = corrcoef(slice_clean,'rows','pairwise');
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
    %----------------------------------------------------------------------------------------------------
    % compute ontological distance between region pairs
    %----------------------------------------------------------------------------------------------------
    % only keep acronyms of structures that are not missing
    acronymPath_clean=acronymPath(iy,:);
    % remove the curly brackets
    for j=1:length(acronymPath_clean)
        acronymPath_clean{j}=acronymPath_clean{j}(2:end-1);
    end
    % make a cell containing each structure as a row of cell
    acronymPathCell=cell(length(acronymPath_clean),1);
    % fill up with the acronym path components
    for j=1:length(acronymPath_clean)
        x=strsplit(acronymPath_clean{j},',');
        acronymPathCell{j}=x;
    end
    pairsIx=cell(length(corrCoeff),1);
    for j=1:length(corrCoeff)
        [iq,ir]=ind2sub4up(j);
        pairsIx{j}=[iq,ir];
    end
    % compare acronym paths
    ontoDist=zeros(length(pairsIx),1);
    for j=1:length(pairsIx)
        commonOnes=nnz(ismember(acronymPathCell{pairsIx{j}(1)},acronymPathCell{pairsIx{j}(2)}));
        ontoDist(j)=(length(acronymPathCell{pairsIx{j}(1)})-commonOnes)...
            +(length(acronymPathCell{pairsIx{j}(2)})-commonOnes);
    % arrayfun(@(i1)all(ismember(A(i1,:),B,'rows','stable'),(1:size(A,1))');
    end
    % filter off data points with no coexpression data available
    isMissing_coexpress=isnan(corrCoeff);
    corrCoeff_clean{i}=(corrCoeff(~isMissing_coexpress));
    distances_clean{i}=distances(~isMissing_coexpress);
    ontoDist_clean{i}=ontoDist(~isMissing_coexpress);
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
    numRegions=length(distances_clean{i});

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
    f=figure('color','w','Position',get(0,'Screensize'));
    %symbol='diamond';
    for k=1:length(distances_clean{i}) % plot the dots one by one
        scatter(distances_clean{i}(k),corrCoeff_clean{i}(k),nodeSize,dotColors_use(k,:),symbol{i},'filled','MarkerEdgeColor',...
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

     str = sprintf('Developing Mouse %s gene coexpression vs distance',timePoints{i});
     title(str,'FontSize',19);
     F=getframe(f)
     % g=figureFullScreen(g,true);
     % set(g, 'PaperPositionMode', 'auto') % to save a figure that is the same size as the figure on the screen

     % save figure
     filename = strcat('GeneCoexpression_scatter','_', timePoints{i},'.jpeg');
     str = fullfile('Outs','gene_coexpression_scatter',filename);
     imwrite(F.cdata,str,'jpeg')
end
%%
% save matlab variables
str=fullfile('Matlab_variables','corrCoeff_distances_ontoDist_clean.mat');
save(str,'distances_clean','corrCoeff_clean','ontoDist_clean');
