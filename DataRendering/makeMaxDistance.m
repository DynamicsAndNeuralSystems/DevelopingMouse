function maxDistances = makeMaxDistance()
timePoints = GiveMeParameter('timePoints');
thisBrainDiv = 'wholeBrain';

maxDistances = zeros(length(timePoints),1);
for i=1:length(timePoints)
    maxDistances(i) = getMaxDistance(thisBrainDiv,timePoints{i});
end

end
