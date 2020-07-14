function renderData(procParams)
% renders raw data into mat variables which are saved in Matlab_variables (these take a long time)
% choice of parameters:
% thisBrainDiv: 'wholeBrain','forebrain','midbrain','hindbrain','Dpallidum'

if nargin < 1
    procParams = GiveMeDefaultProcessingParams();
end

% repeat running this function to create gene expression matrix from
% good genes (wholeBrain,forebrain,midbrain and hindbrain), and from different cell types
makeGeneExpressionMatrix(procParams);

% create distances, correlation and directions for different brain divisions, ...
% % cell types, using good gene subset
createSpatialData(procParams)

% % makes cgeMat and distMat for figure 1
% createSpatialMat('E11pt5','allCellTypes','wholeBrain',numData);
end
