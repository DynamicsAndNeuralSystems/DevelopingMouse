function renderDataFromEnergyGrids(procParams)
% renders raw data into mat variables which are saved in Matlab_variables (these take a long time)

if nargin < 1
    procParams = GiveMeDefaultProcessingParams();
end
%-------------------------------------------------------------------------------
% Loop over all brain divisions and cell types:
brainDivisions = GiveMeParameter('brainDivisions');
cellTypes = GiveMeParameter('cellTypes');

% good genes (wholeBrain,forebrain,midbrain and hindbrain), and from different cell types
for j = 1:length(brainDivisions)
    procParams.thisBrainDiv = brainDivisions{j};
    for k = 1:length(cellTypes)
        procParams.thisCellType = cellTypes{k};
        % Make the gene expression matrix for this brain division and cell type:
        makeGeneExpressionMatrix(procParams);
    end
end

% create distances, correlation and directions for different brain divisions, ...
% cell types, using good gene subset
% makeSpatialData(procParams);

% makes cgeMat and distMat for figure 1
% createSpatialMat('E11pt5','allCellTypes','wholeBrain',numData);

end
