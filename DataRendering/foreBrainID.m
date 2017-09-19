% import forebrain IDs

foreBrain_ID=csvread('F_descendantID.csv',1,1,[1 1 1130 1]);
cd '/scratch/kg98/Gladys'
save('foreBrain_ID.mat','foreBrain_ID')