function renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData,thisBrainDiv,thisCellType)
% renders raw data into mat variables which are saved in Matlab_variables (these take a long time)
% choice of parameters:
% thisBrainDiv: 'wholeBrain','forebrain','midbrain','hindbrain','Dpallidum'

if nargin < 1
    whatNorm = GiveMeParameter('whatNorm');
end
if nargin < 2
    whatVoxelThreshold = GiveMeParameter('whatVoxelThreshold');
end
if nargin < 3
    whatGeneThreshold = GiveMeParameter('whatGeneThreshold');
end
if nargin < 4
    numData = GiveMeParameter('numData');
end
if nargin < 5
    thisBrainDiv = 'wholeBrain';
end
if nargin < 6
    thisCellType = 'allCellTypes';
end

% repeat running this function to create gene expression matrix from
% good genes (wholeBrain,forebrain,midbrain and hindbrain), and from different cell types
makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
                        thisBrainDiv,thisCellType,false);

% create distances, correlation and directions for different brain divisions, ...
% % cell types, using good gene subset
createSpatialData(numData,thisBrainDiv,thisCellType,false)

% % makes cgeMat and distMat for figure 1
% createSpatialMat('E11pt5','allCellTypes','wholeBrain',numData);
end
