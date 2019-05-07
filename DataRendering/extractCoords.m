% extract the coordinates 
coOrds=csvread('structureCenters_adult.csv',1,4,[1,4,1474,6]);
label=csvread('structureCenters_adult.csv',1,2,[1,2,1474,2]);
%%
ID=csvread('structureCenters_adult.csv',1,3,[1,3,1474,3]);
%%
is9=(label==9);
%%
coOrds_is9=coOrds(is9,:);

%%
ID_is9=ID(is9);

%% save
str = fullfile('Processed', 'coOrds_AdultMouse.csv');
dlmwrite(str, coOrds_is9,'delimiter', ',', 'precision', 10);
%%
str = fullfile('Processed', 'ID_AdultMouse.csv');
dlmwrite(str,ID_is9,'delimiter', ',', 'precision', 10);
