% For visualizing what's going on

params = GiveMeDefaultParams();

% Nicer to see all voxels if computationally possible:
params.doSubsample = false;
addPC = true;
doSave = true;

for i = 1:length(params.timePoints)
    fprintf(1,'%u/%u %s\n\n',i,length(params.timePoints),params.timePoints{i});
    PlotExpressionMatrix(params.timePoints{i},params,'subDivision',addPC,doSave);
end
