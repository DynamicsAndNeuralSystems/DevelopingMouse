function makeGeneExpressionMatrices(procParams)
% Loop through time points, running makeGridData

if nargin < 1
    procParams = GiveMeDefaultProcessingParams();
end

% Initialize
timePoints = GiveMeParameter('timePoints');

% full size for 7 time points: 210000, 669369, 806520, 115240, 165550, 136000, 158629
% after filtering off spinal cord, unannotated voxels and only including forebrain,midbrain and hindbrain
% the number of voxels are (from voxelGeneCoexpression_all): 5031,9471,11314,11288,19754,21557,24826
% numData_brainDiv=[587,1000,1000,1000,1000,1000,1000]; % number of data ...
% for each time point when division of brain is under question...
% (instead of all brain)

%-------------------------------------------------------------------------------
% Create gene expression matrix
%-------------------------------------------------------------------------------
% (for each time point according to current data-processing settings):
brainStr = GiveMeFileName(procParams.thisBrainDiv);
cellTypeStr = GiveMeFileName(procParams.thisCellType);
for i = 1:length(timePoints)
    fprintf(1,'Time point %s\n',timePoints{i});
    makeGridData(timePoints{i},procParams);
end

end
