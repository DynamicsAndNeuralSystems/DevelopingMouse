% import hindbrain IDs

hindBrain_ID=csvread('H_descendantID.csv',1,1,[1 1 1089 1]);
str=fullfile('Matlab_variables','hindBrain_ID.mat');
save(str,'hindBrain_ID');
