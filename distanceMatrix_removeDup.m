coOrds = csvread('centre.csv');
fid = fopen('acronym.csv','r');
regAcronyms = textscan(fid,'%s');
fclose(fid);
regAcronyms = regAcronyms{1};

%%
% import structure IDs
ID=csvread('ID.csv');

%% 
%find out duplicate rows
[~,ia,~] = unique(coOrds,'rows','stable');
ixDupRows = setdiff(1:size(coOrds,1), ia);

%% list the IDs of the duplicated coordinates
%ID_of_Dup=ID(ixDupRows);
% list duplicated coordinates
dupCoOrds=coOrds(ixDupRows,:);
%% make a loop thru duplicated coordinates to find out index pairs of duplicated coordinates
dupIxPairs=cell(length(dupCoOrds),1);
for i=1:length(dupCoOrds)
    dupIxPairs{i}=find(ismember(coOrds,dupCoOrds(i,:),'rows'));
end
%% list the IDs of the repeated coordinates
coOrdsDupID=cell(length(dupIxPairs),1);
for i=1:length(dupIxPairs)
    for j=1:length(dupIxPairs{i})
        coOrdsDupID{i}(j)=ID(dupIxPairs{i}(j));
    end
end

%% open acronym file with one word name
fid = fopen('acronym_onewordname.csv','r');
structAcronyms = textscan(fid,'%s');
fclose(fid);
structAcronyms = structAcronyms{1};

%%
% find out duplicate IDs
[~,ia,~]=unique(ID,'stable');
ixDupID=setdiff(1:length(ID),ia);

%% make a loop thru duplicated IDs to find out index pairs of duplicated IDs
dupIxPairs_ID=cell(length(ixDupID),1);
for i=1:length(dupIxPairs_ID)
    dupIxPairs_ID{i}=find(ismember(ID,ID(ixDupID(i))));
end
%% what are the duplicate IDs
dupID=ID(ixDupID);

%% find out abbre of the repeated coordinates
% coOrdsDupAcro=cell(length(dupIxPairs),1);
% for i=1:length(dupIxPairs)
%     for j=1:length(dupIxPairs{i})
%         coOrdsDupAcro{i}(j)=structAcronyms{coOrdsDupID{i}(j)};
%     end
% end
%% turn duplicate ID into NaN, and their corresponding coord to [NaN,NaN,NaN] and abbre to 'None'
ID_clean=ID;
ID_clean(ixDupID,:)=NaN;
coOrds_clean=coOrds;
coOrds_clean(ixDupID,:)=repmat([NaN,NaN,NaN],length(ixDupID),1);
structAcronyms_clean=structAcronyms;
structAcronyms_clean(ixDupID)={''};

%% turn duplicate rows from coOrds_clean into [NaN,NaN,NaN], and their corresponding ID into Nan, abbre to 'None' 
coOrds_clean(ixDupRows,:)=repmat([NaN,NaN,NaN],length(ixDupRows),1);
ID_clean(ixDupRows,:)=NaN;
structAcronyms_clean(ixDupRows)={''};

%%
% remove all NaN from ID, coord and abbre
ID_clean(isnan(ID_clean))=[];
coOrds_clean=coOrds_clean(~any(isnan(coOrds_clean),2),:);
structAcronyms_clean=structAcronyms_clean(~cellfun('isempty',structAcronyms_clean));


%%
%-------------------------------------------------------------------------------
%dataFile = '/Users/benfulcher/GoogleDrive/Work/CurrentProjects/CellTypesMouse/Code/AllenGeneDataset_19419.mat';
%fprintf(1,'New Allen SDK-data from %s\n',dataFile);
%load(dataFile,'structInfo');

load('structInfo.mat')
%%
% Match:
[~,ia,ib] = intersect(structInfo.acronym,structAcronyms_clean,'stable');
structInfo = structInfo(ia,:);
coOrds_clean = coOrds_clean(ib,:);
numRegions = height(structInfo);

%-------------------------------------------------------------------------------
% Get Euclidean distances and rescale to 2d
%-------------------------------------------------------------------------------
distMat = squareform(pdist(coOrds_clean,'euclidean'));
score = mdscale(distMat,2);
xData = score(:,1);
yData = score(:,2);

%-------------------------------------------------------------------------------
% Plot
%-------------------------------------------------------------------------------
f = figure('color','w');
dotColors = arrayfun(@(x) rgbconv(structInfo.color_hex_triplet{x})',...
                                        1:numRegions,'UniformOutput',0);
dotColors = [dotColors{:}]';

nodeSize = 50;
scatter(xData,yData,nodeSize,dotColors,'fill','MarkerEdgeColor','k')

% Add labels:
xDataRange = range(xData);
for i = 1:numRegions
    text(xData(i)+0.04*xDataRange,yData(i),structInfo.acronym{i},...
                        'color',brighten(dotColors(i,:),-0.3))
end

% And for major divisions:
divisionLabels = categorical(structInfo.divisionLabel);
theDivisions = unique(divisionLabels);
numDivisions = length(theDivisions);
for i = 1:numDivisions
    % Put each major region in the center of those points
    centrePoint = [mean(xData(divisionLabels==theDivisions(i))),mean(yData(divisionLabels==theDivisions(i)))];
    find_1 = find(divisionLabels==theDivisions(i),1);
    text(centrePoint(1),centrePoint(2),char(theDivisions(i)), ...
                'color','k','FontSize',14,'BackgroundColor',dotColors(find_1,:))
end
