% Tells me how many genes are good at each time point
params = GiveMeDefaultParams();

numTimePoints = length(params.timePoints);

for i = 1:numTimePoints
    theFile = GiveMeFileName(params.timePoints{i});
    load(theFile,'geneInfo');
    fprintf(1,'%s: %u/%u = %.1f%%\n',params.timePoints{i},...
                sum(geneInfo.isPersistent),...
                sum(geneInfo.isGoodGeneBrain),...
                100*sum(geneInfo.isPersistent)/sum(geneInfo.isGoodGeneBrain));
end
