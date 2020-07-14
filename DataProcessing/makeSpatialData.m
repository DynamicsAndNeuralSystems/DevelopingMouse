function [distances_all,corrCoeff_all,angle_coronal_all,angle_axial_all,angle_sagittal_all] = makeSpatialData(procParams)
% reads in voxel x gene matrix and coordinates and create correlation coefficient,
% distances and angle that a voxel pair makes with each axis
%--------------------------------------------------------------------------------------

% Set up parameters and initialize
timePoints = GiveMeParameter('timePoints');
distances_all = cell(length(timePoints),1);
corrCoeff_all = cell(length(timePoints),1);
angle_coronal_all = cell(length(timePoints),1);
angle_axial_all = cell(length(timePoints),1);
angle_sagittal_all = cell(length(timePoints),1);

% set file string parameters
brainStr = GiveMeFileName(procParams.thisBrainDiv);
if scaledDistance
    distanceStr = GiveMeFileName('scaled');
else
    distanceStr = GiveMeFileName('notScaled');
end
cellTypeStr = GiveMeFileName(procParams.thisCellType);
if procParams.withDirection
    directionStr = GiveMeFileName('withDirection');
else
    directionStr = GiveMeFileName('noDirection');
end

%--------------------------------------------------------------------------------------
% Make the data
for i=1:length(timePoints)
    % no data for E11.5 dorsal pallidum, so skip that
    if (i==1 & strcmp(thisBrainDiv,'Dpallidum'))
        continue
    end
    % only 587 voxels are available in the midbrain in E11.5, ...
    % so override numData if that's more than 587
    if (i==1 & strcmp(thisBrainDiv,'midbrain'))
        numData = 587;
    % only 837 voxels are available in the dorsal pallidum in E13.5,
    elseif (i==2 & strcmp(thisBrainDiv,'Dpallidum'))
        numData = 837;
    else
        numData = procParams.numData;
    end

    % load suitable variables
    filename = sprintf('voxelGeneCoexpression%s%s_%s.mat',...
                        brainStr,cellTypeStr,timePoints{i});
    load(filename,'voxGeneMat','coOrds');

    % sample voxels and compute
    [distances_all{i},...
    corrCoeff_all{i},...
    angle_coronal_all{i},...
    angle_axial_all{i},...
    angle_sagittal_all{i}] = sampleGridData(voxGeneMat,coOrds,timePoints{i},...
                                  scaledDistance,numData,procParams.withDirection);
end

% Save variables
fileOut = fullfile('Matlab_variables',sprintf('spatialData_NumData_%d%s%s%s.mat',...
                                          whatNumData,brainStr,cellTypeStr,...
                                          distanceStr));
if procParams.withDirection
    save(fileOut,'distances_all','corrCoeff_all','angle_coronal_all','angle_axial_all',...
                      'angle_sagittal_all')
else
    save(fileOut,'distances_all','corrCoeff_all')
end

end
