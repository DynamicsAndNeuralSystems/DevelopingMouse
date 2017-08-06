% import spinal cord IDs

spinalCord_ID=csvread('SpC_descendantID.csv',1,1,[1 1 93 1]);
cd '/scratch/kg98/Gladys'
save('spinalCord_ID.mat','spinalCord_ID')