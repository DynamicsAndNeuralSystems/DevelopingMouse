clearvars
%------------------------------------------------------------------------
% Import acronyms, colors, id from StructureData
%------------------------------------------------------------------------
filename = fullfile('Data','API','Structures','structureData_level5.csv');

formatSpec_acronym = '%*s%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
formatSpec_color = '%*s%*s%*s%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
formatSpec_id = '%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray_acronym=readInCSV(filename,formatSpec_acronym);
dataArray_color=readInCSV(filename,formatSpec_color);
dataArray_id=readInCSV(filename,formatSpec_id);

acronym = dataArray_acronym{:, 1};
color_hex_triplet = dataArray_color{:, 1};
id = dataArray_id{:, 1};

%Clear temporary variables
clearvars filename formatSpec_acronym formatSpec_color formatSpec_id dataArray_color dataArray_acronym dataArray_id;
%%
%------------------------------------------------------------------------
% Import reference space ID from StructureCenter.
%------------------------------------------------------------------------
filename = fullfile('Data','API','Structures','structureCenters_level5.csv');

formatSpec_structure_id = '%*s%*s%*s%f%*s%*s%*s%[^\n\r]';
formatSpec_reference_space_id = '%*s%*s%f%*s%*s%*s%*s%[^\n\r]';

dataArray_structure_id=readInCSV(filename,formatSpec_structure_id);
dataArray_reference_space_id=readInCSV(filename,formatSpec_reference_space_id);

structure_id = dataArray_structure_id{:, 1};
structure_reference_space_id = dataArray_reference_space_id{:, 1};

% Clear temporary variables
clearvars filename formatSpec_structure_id formatSpec_reference_space_id dataArray_structure_id dataArray_reference_space_id;
%%
%------------------------------------------------------------------------
% Import acronym path from AcronymPath.
%------------------------------------------------------------------------
%%
filename = fullfile('Data','API','Structures','AcronymPath_level5.csv');

formatSpec_AcronymPath = '%*q%q%q%[^\n\r]';

dataArray_AcronymPath=readInCSV(filename,formatSpec_AcronymPath);

% Clear temporary variables
clearvars filename formatSpec_AcronymPath;

% Organize the acronym path variable
raw = repmat({''},length(dataArray_AcronymPath{1}),length(dataArray_AcronymPath)-1);

for col=1:length(dataArray_AcronymPath)-1
    raw(1:length(dataArray_AcronymPath{col}),col) = dataArray_AcronymPath{col};
end

% Create output variable
acronymPathlevel5clean = raw;

%%
%------------------------------------------------------------------------
% Import import level 3 acronym and color from Structure
%------------------------------------------------------------------------
filename = fullfile('Data','API','Structures','structureData_level3.csv');
acronym_level3 = readInXLS(filename, 'B2:B20');
color_level3 = readInXLS(filename, 'D2:D20');
clearvars filename
%%
%------------------------------------------------------------------------
% Import coordinates from Structure Center
%------------------------------------------------------------------------
filename = fullfile('Data','API','Structures','structureCenters_level5.csv');
coOrds=csvread(filename,1,4,[1,4,805,6]);
clearvars filename
%% 
%------------------------------------------------------------------------
% Create the variable
%------------------------------------------------------------------------
% sort the coordinates into different developmental time points
is1=(structure_reference_space_id==1);
is2=(structure_reference_space_id==2);
is3=(structure_reference_space_id==3);
is5=(structure_reference_space_id==5);
is6=(structure_reference_space_id==6);
is7=(structure_reference_space_id==7);
is8=(structure_reference_space_id==8);
is9=(structure_reference_space_id==9);

coOrds_E11pt5=coOrds(is1,:);
coOrds_E13pt5=coOrds(is2,:);
coOrds_E15pt5=coOrds(is3,:);
coOrds_E18pt5=coOrds(is5,:);
coOrds_P4=coOrds(is6,:);
coOrds_P14=coOrds(is7,:);
coOrds_P28=coOrds(is8,:);
coOrds_P56=coOrds(is9,:);

% sort the acronym path cell into the correct order
[~,iq,ir]=intersect(char(acronym),acronymPathlevel5clean(:,1),'stable');
acronymPathlevel5clean=acronymPathlevel5clean(ir,:);
% extract the acronym of the major division 
acronymPath=acronymPathlevel5clean(:,2);
% break each row into separate words and extract the needed one
divisionLabel=cell(length(acronymPath),1);
divisionColorLabel=cell(length(acronymPath),1);
for i=1:length(acronymPath)
    x=strsplit(acronymPath{i},',');
    divisionLabel{i}=x{ismember(x,char(acronym_level3))};
    divisionColorLabel{i}=color_level3{ismember(char(acronym_level3),divisionLabel{i},'rows')};
end

%match the coordinates with acronym, ID and color
logicalCell={is1,is2,is3,is5,is6,is7,is8,is9};
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28','P56'};
% Initialize the variables
dataDevMouse=struct();
columnNames={'ID','Acronym','Color','Division','Dvision_Color','Coordinates'};
coOrds_filtered=cell(length(timePoints),1);
% first, match coordinates with the 78 level 5 ID
for i=1:length(timePoints)
    [C,ia,ib]=intersect(id,structure_id(logicalCell{i}),'stable');
    coOrds_filtered{i}=coOrds(logicalCell{i},:);
% extract coordinates,id,acronym and color of structures with matching level 5 ID
    dataDevMouse.(timePoints{i}).coOrd=coOrds_filtered{i}(ib,:);
    dataDevMouse.(timePoints{i}).id=id(ia);
    dataDevMouse.(timePoints{i}).acronym=acronym(ia);
    dataDevMouse.(timePoints{i}).division=divisionLabel(ia);
    dataDevMouse.(timePoints{i}).division_color=divisionColorLabel(ia);
    dataDevMouse.(timePoints{i}).color=color_hex_triplet(ia,:);
    dataDevMouse.(timePoints{i}).info=table(dataDevMouse.(timePoints{i}).id,...
        dataDevMouse.(timePoints{i}).acronym,dataDevMouse.(timePoints{i}).color,...
        dataDevMouse.(timePoints{i}).division,dataDevMouse.(timePoints{i}).division_color,...
        dataDevMouse.(timePoints{i}).coOrd,'VariableNames',columnNames);
    dataDevMouse.(timePoints{i}).distance=squareform(pdist(coOrds_filtered{i}(ib,:),'euclidean'));
end
%------------------------------------------------------------------------
% Save the variable
%------------------------------------------------------------------------
str=fullfile('Data','Matlab_variables', 'dataDevMouse.mat');
save(str,'dataDevMouse');