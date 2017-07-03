% extract the coordinates from the server
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
dlmwrite('coOrds_AdultMouse.csv',coOrds_is9,'delimiter', ',', 'precision', 10);
%%
dlmwrite('ID_AdultMouse.csv',ID_is9,'delimiter', ',', 'precision', 10);
