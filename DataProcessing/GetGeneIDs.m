function geneIDs = GetGeneIDs(timePointNow)
% Iterate through the folders storing grid expression data to retrieve the gene IDs
%-------------------------------------------------------------------------------

timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints)); %match index to the chosen timepoint
fileTimePoints = GiveMeParameter('fileTimePoints');


str = fullfile('Data','API','GridData',fileTimePoints{timePointIndex});
A = dir(str);
% remove hidden files
A = A(arrayfun(@(A) A.name(1), A) ~= '.');
numGenes = length(A);

geneIDs = cell(numGenes,1);
for j = 1:numGenes
    infoStr = strsplit(A(j).name,'_');
    geneIDs = str2double(infoStr{2});
end

end
