% PlotAll3dSpatial
% For visualizing what's going on in three-dee space, mate
%-------------------------------------------------------------------------------

params = GiveMeDefaultParams();

% Nicer to see all voxels if computationally possible:
params.doSubsample = false;
subSample = 5000;
doSave = true;

for i = 3:length(params.timePoints)
    fprintf(1,'%u/%u %s\n\n',i,length(params.timePoints),params.timePoints{i});
    VisualizeSpatialExpression(params.timePoints{i},'','turboOne',subSample)
    beep
    w = input('Are you ready?','s');
end
