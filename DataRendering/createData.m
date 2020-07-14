function createData(fromScratch,procParams)
% create most of the data; if fromScratch is true, creates data starting from raw data; otherwise,
% create data starting from energyGrids matlab variables

if nargin < 1
    fromScratch = false;
end
if nargin < 2
    procParams = GiveMeDefaultProcessingParams();
end
%-------------------------------------------------------------------------------

renderDataFromEnergyGrids(procParams);

% if fromScratch
    % renderData(procParams);
    % makeGeneExpressionMatrix(procParams);
% else
% end

end
