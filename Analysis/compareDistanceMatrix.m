% read in acronyms
if exist('acronym_AdultMouse.csv','file')
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
% scatter plot for MDS
f=plotStructures_scatter(xData, yData, structInfo.color_hex_triplet, structInfo.acronym, structInfo.divisionLabel, numRegions, 'API data MDS plot')
% save it
str=fullfile('Outs','compare_distance_matrix','MDS_API.jpeg');
saveas(f,str)

% %% scatter3 plot
coOrds_x=coOrds_clean(:,1);
coOrds_y=coOrds_clean(:,2);
coOrds_z=coOrds_clean(:,3);
f=plotStructures_scatter3(coOrds_x, coOrds_y, coOrds_z, structInfo.color_hex_triplet, structInfo.acronym, structInfo.divisionLabel, numRegions, 'API data Scatter3 plot')
str=fullfile('Outs','compare_distance_matrix','scatter3_API.jpeg');
saveas(f,str)

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
f=plotStructures_scatter(xData_Oh,yData_Oh,structInfo.color_hex_triplet,structInfo.acronym,structInfo.divisionLabel,numRegions,'Oh et al data MDS')
% save figure
str=fullfile('Outs','compare_distance_matrix','MDS_Oh_et_al.jpeg');
saveas(f,str)

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
str=sprintf('The proportion of entries more than 5 percent different compared to Oh et al is %f', proportion);
text(4000,100,str,'FontSize',12);
set(t,'Fontsize',18);
f=figureFullScreen(f,true);
set(f, 'PaperPositionMode', 'auto');
str=fullfile('Outs','compare_distance_matrix','percentage_error_vs_distance.jpeg');
saveas(f,str)
