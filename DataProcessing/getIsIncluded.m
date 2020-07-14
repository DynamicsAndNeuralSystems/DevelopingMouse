function isIncluded = getIsIncluded(thisBrainDiv,timePointNow)
% Specifies voxels to include
%-------------------------------------------------------------------------------

% Load variables
load('annotationGrids.mat','annotationGrids')
load('brainDivision.mat','brainDivision')

% Match to get annotation grid for current time point:
timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints)); % match index to the chosen timepoint
myAnnotationGrid = annotationGrids{timePointIndex};

%-------------------------------------------------------------------------------
% Match by ID:
switch thisBrainDiv
case 'wholeBrain'
    wholeBrainIDs = union([brainDivision.forebrain.ID,...
                brainDivision.midbrain.ID,brainDivision.hindbrain.ID]);
    isIncluded = ismember(myAnnotationGrid,wholeBrainIDs);
case 'forebrain'
    isIncluded = ismember(myAnnotationGrid,brainDivision.forebrain.ID);
case 'midbrain'
    isIncluded = ismember(myAnnotationGrid,brainDivision.midbrain.ID);
case 'hindbrain'
    isIncluded = ismember(myAnnotationGrid,brainDivision.hindbrain.ID);
case 'Dpallidum'
    isIncluded = ismember(myAnnotationGrid,brainDivision.Dpallidum.ID);
otherwise
    error('Unknown brain division: ''%s''',thisBrainDiv)
end

end
