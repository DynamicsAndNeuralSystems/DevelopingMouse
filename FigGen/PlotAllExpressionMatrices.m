% For visualizing what's going on

params = GiveMeDefaultParams();

% Nicer to see all voxels if computationally possible:
params.doSubsample = false;

timePoints = GiveMeParameter('timePoints');
for i = 1:length(timePoints)
    fprintf(1,'%u/%u %s\n\n',i,length(timePoints),timePoints{i});
    PlotExpressionMatrix(timePoints{i},params,'subDivision');
end
