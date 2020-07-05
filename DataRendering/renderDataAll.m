function renderDataAll(whatNorm,whatVoxelThreshold,whatGeneThreshold,numData)
  % default parameters
  if nargin < 4
    numData=GiveMeParameter('numData');
  end
  if nargin < 3
    whatGeneThreshold=GiveMeParameter('whatGeneThreshold');
  end
  if nargin < 2
    whatVoxelThreshold=GiveMeParameter('whatVoxelThreshold');
  end
  if nargin < 1
    whatNorm=GiveMeParameter('whatNorm');
  end
  % get other parameters for looping
  brainDivisions = GiveMeParameter('brainDivisions');
  cellTypes = GiveMeParameter('cellTypes');
  % data rendering for different combinations of brain divisions, cell types
  for j=1:length(brainDivisions)
      for m=1:length(cellTypes)
          renderData(whatNorm,whatVoxelThreshold,whatGeneThreshold,...
          numData,brainDivisions{j},cellTypes{m});
      end
  end
end
