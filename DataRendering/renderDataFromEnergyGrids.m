function renderDataFromEnergyGrids(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData)
% renders raw data into mat variables which are saved in Matlab_variables (these take a long time)

% Set Defaults:
if nargin < 1
    whatNorm=GiveMeParameter('whatNorm');
end
if nargin < 2
    whatVoxelThreshold=GiveMeParameter('whatVoxelThreshold');
end
if nargin < 3
    numThresholds=GiveMeParameter('numThresholds');
end
if nargin < 4
    numData=GiveMeParameter('numData');
end
%-------------------------------------------------------------------------------

brainDivisions=GiveMeParameter('brainDivisions');
cellTypes=GiveMeParameter('cellTypes');

% good genes (wholeBrain,forebrain,midbrain and hindbrain), and from different cell types
for j=1:length(brainDivisions)
    for k=1:length(cellTypes)
        makeGeneExpressionMatrix(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
                          brainDivisions{j},cellTypes{k},true);
    end
end

% create distances, correlation and directions for different brain divisions, ...
% cell types, using good gene subset
createSpatialData(numData,false);

% makes cgeMat and distMat for figure 1
createSpatialMat('E11pt5','allCellTypes','wholeBrain',numData);

end
