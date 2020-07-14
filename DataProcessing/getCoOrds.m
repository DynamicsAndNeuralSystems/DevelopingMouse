function coOrds = getCoOrds(thisBrainDiv,timePointNow)
% getCoOrds Get coordinates for voxels in a given brain division
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% load variables
load('annotationGrids.mat','annotationGrids')
load('spinalCord_ID.mat','spinalCord_ID')
load('brainDivision.mat','brainDivision')

% load parameters
sizeGrids = GiveMeParameter('sizeGrids');
timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints)); % match index to the chosen timepoint

myAnnotationGrid = annotationGrids{timePointIndex};

% filters off spinal cord voxels
isSpinalCord = ismember(myAnnotationGrid,spinalCord_ID);
isAnno = (myAnnotationGrid>0);
isIncluded = getIsIncluded(thisBrainDiv,timePointNow);

% get all coordinates
[a,b,c] = ind2sub(sizeGrids.(timePoints{timePointIndex}),find(isAnno & ~isSpinalCord & isIncluded));
coOrds = horzcat(a,b,c);

end
