function number = checkGeneOverlap(timePoint1,timePoint2)
  if nargin ~= 2
    error('You must give two time points')
  end
  % Set up time points:
  fileTimePoints = GiveMeParameter('fileTimePoints');
  timePoints = GiveMeParameter('timePoints');
  timePointIndex = zeros(2,1);
  timePointsHere = {timePoint1,timePoint2};
  expression_loc = cell(2,1);
  A = cell(2,1);
  geneIDInfo= cell(2,1);
  % match index to the chosen timepoint
  for i = 1:length(timePointIndex)
    timePointIndex(i) = find(strcmp(timePointsHere{i},timePoints));
    expression_loc{i} = fullfile('Data','API','GridData',fileTimePoints{timePointIndex(i)});
    A{i} = dir(expression_loc{i});
    A{i} = A{i}(arrayfun(@(A) A.name(1), A{i}) ~= '.');
    numGenes = length(A{i});
    % extract gene ID
    for j = 1:numGenes
      infoStr = strsplit(A{i}(j).name,'_');
      geneIDInfo{i}(j) = str2double(infoStr{2});
    end
  end
  % compare gene ID and give the number of overlapping genes
  number = nnz(ismember(geneIDInfo{1},geneIDInfo{2}));
end
