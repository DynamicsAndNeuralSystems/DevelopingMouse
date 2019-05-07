function makeEnergyGrid()

timePoints = GiveMeParameter('timePoints');
for i=1:length(timePoints)
    readGridData(timePoints{i});
end

end
