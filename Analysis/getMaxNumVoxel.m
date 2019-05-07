% get max number of voxels available in each time point
% load variables
load('annotationGrids.mat')
load('spinalCord_ID.mat')
load('brainDivision.mat')

timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% initialize
maxNumVoxel=cell(length(timePoints),1);

for i=1:length(timePoints)
  load(strcat('energyGrids_',timePoints{timePointIndex},'.mat'));
  % include suitable brain divisions
  isIncluded=or(or(ismember(annotationGrids{i},brainDivision.forebrain.ID),...
                    ismember(annotationGrids{i},brainDivision.midbrain.ID)),...
                    ismember(annotationGrids{i},brainDivision.hindbrain.ID));
  % filters off spinal cord voxels
  isSpinalCord=ismember(annotationGrids{i},spinalCord_ID);
  % only keep annotated voxels
  isAnno=annotationGrids{timePointIndex}>0;
end
