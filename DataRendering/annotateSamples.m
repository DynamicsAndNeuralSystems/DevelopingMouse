function annotateSamples(timePointNow,procParams)
% Load voxelGeneExpression_*.mat and annotate a random sample
%-------------------------------------------------------------------------------
if nargin < 2
    procParams = GiveMeDefaultParams();
end

% Load voxel label data for this time point:
fileName = GiveMeFileName(timePointNow);
load(fileName,'voxLabelTable','voxGeneMat')
numVoxels = height(voxLabelTable);

% Filter by regions of interest
sampleBrain = false(numVoxels,1);
sampleForebrain = false(numVoxels,1);
sampleMidbrain = false(numVoxels,1);
sampleHindbrain = false(numVoxels,1);
sampleDpall = false(numVoxels,1);


%-------------------------------------------------------------------------------
% VOXEL SUBSAMPLING
makeSample = @(xInd) xInd(randsample(length(xInd),min(length(xInd),procParams.numData)));

% Define brain as forebrain/midbrain/hindbrain...?
isGoodVoxel = (mean(isnan(voxGeneMat),2) < procParams.whatVoxelThreshold);
isBrain = (voxLabelTable.isForebrain | voxLabelTable.isMidbrain | voxLabelTable.isHindbrain);
brainInd = find(isBrain & isGoodVoxel);
forebrainInd = find(voxLabelTable.isForebrain & isGoodVoxel);
midbrainInd = find(voxLabelTable.isMidbrain & isGoodVoxel);
hindbrainInd = find(voxLabelTable.isHindbrain & isGoodVoxel);
DpallInd = find(voxLabelTable.isDpall & isGoodVoxel);

% Assign to sample columns:
sampleBrain(makeSample(brainInd)) = true;
sampleForebrain(makeSample(forebrainInd)) = true;
sampleMidbrain(makeSample(midbrainInd)) = true;
sampleHindbrain(makeSample(hindbrainInd)) = true;
sampleDpall(makeSample(DpallInd)) = true;

% Add as columns:
voxLabelTable.isBrain = isBrain;
voxLabelTable.sampleBrain = sampleBrain;
voxLabelTable.sampleForebrain = sampleForebrain;
voxLabelTable.sampleMidbrain = sampleMidbrain;
voxLabelTable.sampleHindbrain = sampleHindbrain;
voxLabelTable.sampleDpall = sampleDpall;

% Save back:
save(fileName,'voxLabelTable','-append')

end
