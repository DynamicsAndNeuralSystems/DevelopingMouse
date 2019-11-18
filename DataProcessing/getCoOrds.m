function [coOrds] = getCoOrds(thisBrainDiv,timePointNow)
  % load parameters
  sizeGrids = GiveMeParameter('sizeGrids');
  timePoints = GiveMeParameter('timePoints');
  timePointIndex = find(strcmp(timePointNow,timePoints)); %match index to the chosen timepoint
  % load variables
  load('annotationGrids.mat','annotationGrids')
  load('spinalCord_ID.mat','spinalCord_ID')
  load('brainDivision.mat','brainDivision')

  % filters off spinal cord voxels
  isSpinalCord=ismember(annotationGrids{timePointIndex},spinalCord_ID);
  isAnno=annotationGrids{timePointIndex}>0;

  isIncluded = getIsIncluded(thisBrainDiv,timePointNow);

  % get all coordinates
  [a,b,c]=ind2sub(sizeGrids.(timePoints{timePointIndex}),find(isAnno & ~isSpinalCord & isIncluded));
  coOrds=horzcat(a,b,c);
end
