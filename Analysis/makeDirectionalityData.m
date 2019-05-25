% function makeDirectionalityData(numData,scaledDistance,thisDirection)
numData=1000;
scaledDistance = false;
thisDirection = 'sagittal';
  % extracts distances and correlation coefficients of given direction
timePoints=GiveMeParameter('timePoints');
% set file string parameters
if scaledDistance
  distanceStr = GiveMeFileName('scaled');
else
  distanceStr = GiveMeFileName('notScaled');
end
directionStr = GiveMeFileName(thisDirection);
filestr = sprintf('spatialData_NumData_%d%s',numData,distanceStr);
% angle_all = eval(sprintf('angle_%s_all',thisDirection));
angle_all = sprintf('angle_%s_all',thisDirection);
spatialData = load(filestr, 'distances_all','corrCoeff_all',angle_all);

isRightDir = cell(length(timePoints),1);

distances_all = cell(length(timePoints),1);
corrCoeff_all = cell(length(timePoints),1);

for i=1:length(timePoints)
  % get indices of voxel pairs in axial direction
  isRightDir{i} = (spatialData.(angle_all){i}<=(pi/4)|...
                ((spatialData.(angle_all){i}>=(3/4*pi))&(spatialData.(angle_all){i}<=(5/4*pi)))|...
                (spatialData.(angle_all){i}>=(7/4*pi)));
  distances_all{i}=spatialData.distances_all{i}(isRightDir{i});
  corrCoeff_all{i}=spatialData.corrCoeff_all{i}(isRightDir{i});
end
filestr = sprintf('directionalityData%s%s.mat',directionStr,distanceStr);
str=fullfile('Matlab_variables',filestr);

save(str,'distances_all','corrCoeff_all')
% end
