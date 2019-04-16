function readSpinalCordID()
% user input: location to save the created matlab variable
save_loc=fullfile('Data','Matlab_variables');
% import spinal cord IDs
spinalCord_ID=csvread('SpC_descendantID.csv',1,1,[1 1 93 1]);
str=strcat(save_loc,'\','spinalCord_ID.mat');
save(str,'spinalCord_ID')
end
