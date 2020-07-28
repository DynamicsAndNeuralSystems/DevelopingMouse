function maxDistances = makeMaxDistance(params)
% Get maximum distances across the seven time points
if nargin < 1
    params = GiveMeDefaultParams();
end
numTimePoints = length(params.timePoints);
%-------------------------------------------------------------------------------

maxDistances = zeros(numTimePoints,1);
for i = 1:numTimePoints
    maxDistances(i) = getMaxDistance(params.timePoints{i});
end

end
