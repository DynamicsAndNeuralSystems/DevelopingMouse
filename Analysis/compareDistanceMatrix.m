% read in acronyms
if exist('acronym_AdultMouse.csv','file')
    % fid = fopen('acronym_AdultMouse.csv','r');
    % structAcronyms = textscan(fid,'%s');
    % fclose(fid);
    structAcronyms = importfile_acronym('acronym_AdultMouse.csv')
else
    error('acronym_AdultMouse.csv is missing')
end
% read in coordinates
if exist('coOrds_AdultMouse.csv','file')
    coOrds = csvread('coOrds_AdultMouse.csv');
else
    error('coOrds_AdultMouse.csv is missing')
end
% read in ID
if exist('ID_AdultMouse.csv','file')
    % import structure IDs
    ID=csvread('ID_AdultMouse.csv');
else
    error('ID_AdultMouse.csv is missing')
end
% remove duplications
[coOrds_clean,ia,~] = unique(coOrds,'rows','stable');
structAcronyms_clean=structAcronyms(ia);
ID_clean=ID(ia);

% load matlab variable containing adult mouse strcuture data
if exist('structInfo.mat','file')
    load('structInfo.mat')
else
    error('structInfo.mat is missing')
end

% Match:
[~,ia,ib] = intersect(structInfo.acronym,structAcronyms_clean,'stable');
structInfo = structInfo(ia,:);
coOrds_clean = coOrds_clean(ib,:);
structAcronyms_clean=structAcronyms_clean(ib,:);
ID_clean=ID_clean(ib,:);
% obtain the number of regions of the table
numRegions = height(structInfo);
%%
%-------------------------------------------------------------------------------
% Get Euclidean distances and rescale to 2d
%-------------------------------------------------------------------------------
distMat = squareform(pdist(coOrds_clean,'euclidean'));
score = mdscale(distMat,2,'Criterion','metricsstress');
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
t=title('API data MDS plot');
set(t,'Fontsize',18)
%% scatter3 plot
coOrds_x=coOrds_clean(:,1);
coOrds_y=coOrds_clean(:,2);
coOrds_z=coOrds_clean(:,3);
f1 = figure('color','w');
scatter3(coOrds_x,coOrds_y,coOrds_z,nodeSize,dotColors,'fill','MarkerEdgeColor','k');
xlabel('x');
ylabel('y');
zlabel('z');

% Add labels:
xCoordRange = range(coOrds_x);
for i = 1:numRegions
    text(coOrds_x(i)+0.04*xCoordRange,coOrds_y(i),coOrds_z(i),structInfo.acronym{i},...
                        'color',brighten(dotColors(i,:),-0.3))
end

% And for major divisions:
divisionLabels = categorical(structInfo.divisionLabel);
theDivisions = unique(divisionLabels);
numDivisions = length(theDivisions);
for i = 1:numDivisions
    % Put each major region in the center of those points
    centrePoint = [mean(coOrds_x(divisionLabels==theDivisions(i))),mean(coOrds_y(divisionLabels==theDivisions(i))),mean(coOrds_z(divisionLabels==theDivisions(i)))];
    find_1 = find(divisionLabels==theDivisions(i),1);
    text(centrePoint(1),centrePoint(2),centrePoint(3),char(theDivisions(i)), ...
                'color','k','FontSize',14,'BackgroundColor',dotColors(find_1,:))
end
t=title('API data Scatter3 plot');
set(t,'Fontsize',18)
%% Plot for Oh et al data
% import Oh et al labels and matrix
if exist ('A mesoscale connectome of the mouse brain supp table 4_ipsi.xlsx','file')
    [~,labels_Oh,~]=xlsread('A mesoscale connectome of the mouse brain supp table 4_ipsi.xlsx',1,'A2:A296');
    distMat_Oh=xlsread('A mesoscale connectome of the mouse brain supp table 4_ipsi.xlsx',1,'B2:KJ296');
else
    error('A mesoscale connectome of the mouse brain supp table 4_ipsi.xlsx is missing')
end
%%
% Match:
[sameLabel,ix,iy]=intersect(labels_Oh,structAcronyms_clean,'stable');
distMat_new=distMat(iy,iy);
distMat_Oh_new=distMat_Oh(ix,ix);
[~,ia,ib] = intersect(structInfo.acronym,labels_Oh(ix),'stable');
structInfo = structInfo(ia,:);
%coOrds_clean = coOrds_clean(ib,:);
numRegions_Oh = height(structInfo);
%%
%-------------------------------------------------------------------------------
% Get Euclidean distances and rescale to 2d
%-------------------------------------------------------------------------------
%distMat = squareform(pdist(coOrds_clean,'euclidean'));
score = mdscale(distMat_Oh_new,2);
xData_Oh = score(:,1);
yData_Oh = score(:,2);

%-------------------------------------------------------------------------------
% Plot
%-------------------------------------------------------------------------------
f = figure('color','w');
dotColors = arrayfun(@(x) rgbconv(structInfo.color_hex_triplet{x})',...
                                        1:numRegions_Oh,'UniformOutput',0);
dotColors = [dotColors{:}]';

nodeSize = 50;
scatter(xData_Oh,yData_Oh,nodeSize,dotColors,'fill','MarkerEdgeColor','k')

% Add labels:
xDataRange = range(xData);
for i = 1:numRegions
    text(xData_Oh(i)+0.04*xDataRange,yData_Oh(i),structInfo.acronym{i},...
                        'color',brighten(dotColors(i,:),-0.3))
end

% And for major divisions:
divisionLabels = categorical(structInfo.divisionLabel);
theDivisions = unique(divisionLabels);
numDivisions = length(theDivisions);
for i = 1:numDivisions
    % Put each major region in the center of those points
    centrePoint = [mean(xData_Oh(divisionLabels==theDivisions(i))),mean(yData_Oh(divisionLabels==theDivisions(i)))];
    find_1 = find(divisionLabels==theDivisions(i),1);
    text(centrePoint(1),centrePoint(2),char(theDivisions(i)), ...
                'color','k','FontSize',14,'BackgroundColor',dotColors(find_1,:))
end
t=title('Oh et al data MDS');
set(t,'Fontsize',18)
%% Checking the difference between current distance matrix and Oh et al

diffMat=distMat_new-distMat_Oh_new;
%%
distMat_new(distMat_new==0)=NaN;
distMat_Oh_new(distMat_Oh_new==0)=NaN;

divideMat=zeros(size(distMat_new));
t=~isnan(distMat_new);
divideMat(t)=distMat_new(t)./distMat_Oh_new(t);
%% calculate the proportion of entries that are >1.05 or <0.95 compared to Oh distance matrix
proportion=(nnz(logical(divideMat >=1.05|divideMat <=0.95))-size(divideMat,1))/((size(divideMat,1))*size(divideMat,1)-size(divideMat,1));
fprintf('The proportion of entries more than 5 percent different compared to Oh et al is %f \n',proportion)

%%
% cd 'D:\Data\DevelopingAllenMouseAPI-master\Allen annotation volume\Reference space\Atlas 2011\Matlab data'
% save('diffMat_AdultMouse_API.mat','diffMat')
% save('divideMat_AdultMouse_API.mat','divideMat')

%% Plot % error against Oh distance
% compute percentage error matrix
errorMat=zeros(size(distMat_new));
errorMat(t)= ((distMat_new(t)-distMat_Oh_new(t))./distMat_Oh_new(t))*100;
%%
%extract upper triangular part of the errorMat and distMat_Oh_new
errorMat_triu=errorMat(find(triu(ones(size(errorMat)),1)));
distMat_Oh_new_triu=distMat_Oh_new(find(triu(ones(size(distMat_Oh_new)),1)));
%% Actual plotting
f=figure('color','w');
scatter(distMat_Oh_new_triu,errorMat_triu)
xlabel('Distance between structures in Oh et al (um)')
ylabel('% error')
t=title('Percentage error against separation distance in Oh et al');
set(t,'Fontsize',18)
