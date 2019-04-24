timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% create annotation grids
makeAnnotationGrids();
% create spinal cord ID
readSpinalCordID();

for i=1:length(timePoints)
  readGridData(timePoints{i});
end
