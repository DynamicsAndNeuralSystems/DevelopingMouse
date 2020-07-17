function renderDataAll(procParams)

if nargin < 1
    procParams = GiveMeDefaultParams()
end
%-------------------------------------------------------------------------------

% Get other parameters for looping
brainDivisions = GiveMeParameter('brainDivisions');
cellTypes = GiveMeParameter('cellTypes');

% data rendering for different combinations of brain divisions, cell types
for j = 1:length(brainDivisions)
    procParams.thisBrainDiv = brainDivisions{j};
    for m = 1:length(cellTypes)
        procParams.thisCellType = cellTypes{m};
        renderData(procParams);
    end
end

end
