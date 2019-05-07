% import forebrain IDs
foreBrain_ID=csvread('F_descendantID.csv',1,1,[1 1 1130 1]);
str=fullfile('Matlab_variables','foreBrain_ID.mat');
save(str,'foreBrain_ID');
