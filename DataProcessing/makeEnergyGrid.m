function makeEnergyGrid(procParams)

if nargin < 1
    procParams = GiveMeDefaultParams();
end
%-------------------------------------------------------------------------------

timePoints = GiveMeParameter('timePoints');
numTimePoints = length(timePoints);

for i = 1:numTimePoints
    fprintf(1,'Time point %u/%u\n',i,numTimePoints);
    readGridData(timePoints{i},procParams);
    % -> energyGrids%s.mat
end


end
