% determine directionality
% read in the coordinates and voxgenemat
coronalVec=[1 0 0]; % front-back
axialVec=[0 1 0]; % top-down
sagittalVec=[0 0 1]; % left-right

% determine angle made with the three directions between two voxels
vec=[1 2 3] % for example
angle_coronal=acos((dot(vec,coronalVec))/(norm(vec)*norm(coronalVec)));
angle_axial=acos((dot(vec,axialVec))/(norm(vec)*norm(axialVec)));
angle_sagittal=acos((dot(vec,sagittalVec))/(norm(vec)*norm(sagittalVec)));
