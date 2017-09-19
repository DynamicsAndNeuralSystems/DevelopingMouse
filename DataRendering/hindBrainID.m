% import hindbrain IDs

hindBrain_ID=csvread('H_descendantID.csv',1,1,[1 1 1089 1]);
cd '/scratch/kg98/Gladys'
save('hindBrain_ID.mat','hindBrain_ID')