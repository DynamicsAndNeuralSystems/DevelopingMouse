function makeEnergyGrid(procParams)

if nargin < 1
    procParams = GiveMeDefaultParams();
end
%-------------------------------------------------------------------------------

timePoints = GiveMeParameter('timePoints');
numTimePoints = length(timePoints);

if procParams.usePersistentGenes
    error('I don''t think this should ever happen (can always filter by gene/cell-type during analysis)');
    % Let's also make the energy grids for the custom cell types
    cellTypes = GiveMeParameter('cellTypes');
    numCellTypes = length(cellTypes);
    for i = 1:numTimePoints
        fprintf(1,'Time point %u/%u\n',i,numTimePoints);
        for j = 1:numCellTypes
            fprintf(1,'Cell type %u/%u\n',j,numCellTypes);
            readGridData(timePoints{i},procParams);
            % -> energyGrids_goodGeneSubset_%s.mat
        end
    end
else
    for i = 1:numTimePoints
        fprintf(1,'Time point %u/%u\n',i,numTimePoints);
        readGridData(timePoints{i},procParams);
        % -> energyGrids%s.mat
    end
end

end
