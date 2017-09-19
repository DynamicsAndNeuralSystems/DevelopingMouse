% import midbrain IDs

midBrain_ID=csvread('M_descendantID.csv',1,1,[1 1 176 1]);
cd '/scratch/kg98/Gladys'
save('midBrain_ID.mat','midBrain_ID')