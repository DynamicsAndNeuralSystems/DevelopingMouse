% import midbrain IDs

midBrain_ID=csvread('M_descendantID.csv',1,1,[1 1 176 1]);
str=fullfile('Matlab_variables','midBrain_ID.mat');
save(str,'midBrain_ID');
