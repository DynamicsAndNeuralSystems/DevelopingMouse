function makeEnergyGrid(useGoodGeneSubset)

timePoints = GiveMeParameter('timePoints');
cellTypes = GiveMeParameter('cellTypes');
if useGoodGeneSubset
  for i=1:length(timePoints)
      for j=length(cellTypes)
        readGridData(timePoints{i},true,cellTypes{j});
      end
  end
else 
  for i=1:length(timePoints)
    readGridData(timePoints{i},false,'allCellTypes');
  end
end
end
