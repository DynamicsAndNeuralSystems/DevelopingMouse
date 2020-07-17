function LoadSubset(params,timePointNow)

% Get all data for this time point:
theFile = GiveMeFileName(timePointNow);
load(theFile,'coOrds','voxGeneMat','voxLabelTable');

% Take a voxel subset:
if params.doSubsample
    switch params.thisBrainDiv
    case {'brain','wholeBrain'}
        keepMe = voxLabelTable.sampleBrain;
    case 'forebrain'
        keepMe = voxLabelTable.sampleForebrain;
    case 'midbrain'
        keepMe = voxLabelTable.sampleMidbrain;
    case 'hindbrain'
        keepMe = voxLabelTable.sampleHindbrain;
    case 'Dpall'
        keepMe = voxLabelTable.sampleDpall;
    end
else
    warning('need to implement non-sample as e.g., ''isHindbrain''')
end

% Take a gene subset
switch params.thisCellType
case 'allCellTypes'
    
end


end
