function readSpinalCordID()
% Reads in SpC_descendantID.csv (from Allen API) and saves out to spinalCord_ID.mat

% Location to save the created matlab variable
save_loc = fullfile('Data','Matlab_variables');

% Import spinal cord IDs from API csv file:
spinalCord_ID = csvread('SpC_descendantID.csv',1,1,[1 1 93 1]);
str = fullfile('Matlab_variables','spinalCord_ID.mat');
save(str,'spinalCord_ID')

end
