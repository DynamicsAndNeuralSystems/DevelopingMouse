function AnnotateAllGenes()

timePoints = GiveMeParameter('timePoints');
numTimePoints = length(timePoints);
for i = 1:numTimePoints
    fprintf(1,'Time point %s\n',timePoints{i});
    annotateGenes(timePoints{i});
end

end
