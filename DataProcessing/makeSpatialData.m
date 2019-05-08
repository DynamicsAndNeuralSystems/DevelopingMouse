function [distances_all,corrCoeff_all,angle_coronal_all,angle_axial_all,angle_sagittal_all]=makeSpatialData(whatNumData,...
                                                                                                            thisBrainDiv,...
                                                                                                            scaledDistance,...
                                                                                                            thisCellType, ...
                                                                                                            withDirection)
% reads in voxel x gene matrix and coordinates and create correlation coefficient,
% distances and angle that a voxel pair makes with each axis
%--------------------------------------------------------------------------------------
% sets parameters up and initializes
  timePoints = GiveMeParameter('timePoints');
  distances_all=cell(length(timePoints),1);
  corrCoeff_all=cell(length(timePoints),1);
  angle_coronal_all=cell(length(timePoints),1);
  angle_axial_all=cell(length(timePoints),1);
  angle_sagittal_all=cell(length(timePoints),1);
  % set file string parameters
  brainStr = GiveMeFileName(thisBrainDiv);
  if scaledDistance
    distanceStr = GiveMeFileName('scaled');
  else
    distanceStr = GiveMeFileName('notScaled');
  end
  cellTypeStr = GiveMeFileName(thisCellType);
  if withDirection
    directionStr = GiveMeFileName('withDirection');
  else
    directionStr = GiveMeFileName('noDirection');
  end
%--------------------------------------------------------------------------------------
% make the data
  for i=1:length(timePoints)
    % only 587 voxels are available in the midbrain in E11.5, ...
    % so override numData if that's more than 587
    if (i==1 & strcmp(thisBrainDiv,'midbrain'))
      numData=587;
    else
      numData=whatNumData;
    end
    % load suitable variables
    filename=sprintf('voxelGeneCoexpression%s%s_%s.mat',...
                    brainStr,cellTypeStr,timePoints{i});
    load(filename,'voxGeneMat','coOrds');
    % sample voxels and compute
    [distances_all{i},...
    corrCoeff_all{i},...
    angle_coronal_all{i},...
    angle_axial_all{i},...
    angle_sagittal_all{i}]=sampleGridData(voxGeneMat,coOrds,numData,timePoints{i},...
                                          scaledDistance,withDirection);
  end
  % saves variables
  str=fullfile('Matlab_variables',sprintf('spatialData_NumData_%d%s%s%s.mat',...
                                          whatNumData,brainStr,cellTypeStr,...
                                          distanceStr));
  if withDirection
    save(str,'distances_all','corrCoeff_all','angle_coronal_all','angle_axial_all',...
      'angle_sagittal_all')
  else
    save(str,'distances_all','corrCoeff_all')
  end
end
