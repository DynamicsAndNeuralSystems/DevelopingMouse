function makeDirectionalityData(numData,scaledDistance)
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
if scaledDistance
  load(strcat('spatialData_NumData_',num2str(numData),'_scaled_goodGeneSubset','.mat'))
else
  load(strcat('spatialData_NumData_',num2str(numData),'_goodGeneSubset','.mat'))
end
isCoronal=cell(length(timePoints),1);
isAxial=cell(length(timePoints),1);
isSagittal=cell(length(timePoints),1);
distances_sagittal=cell(length(timePoints),1);
corrCoeff_sagittal=cell(length(timePoints),1);
distances_axial=cell(length(timePoints),1);
corrCoeff_axial=cell(length(timePoints),1);
distances_coronal=cell(length(timePoints),1);
corrCoeff_coronal=cell(length(timePoints),1);
for i=1:length(timePoints)
  % get indices of voxel pairs in axial direction
  isCoronal{i}=(angle_coronal_all{i}<=(1/4)|...
                ((angle_coronal_all{i}>=(3/4))&(angle_coronal_all{i}<=(5/4)))|...
                (angle_coronal_all{i}>=(7/4)));
  isAxial{i}=(angle_axial_all{i}<=(1/4)|...
                ((angle_axial_all{i}>=(3/4))&(angle_axial_all{i}<=(5/4)))|...
                (angle_axial_all{i}>=(7/4)));
  isSagittal{i}=(angle_sagittal_all{i}<=(1/4)|...
                ((angle_sagittal_all{i}>=(3/4))&(angle_sagittal_all{i}<=(5/4)))|...
                (angle_sagittal_all{i}>=(7/4)));
  % obtain sagittal info
  distances_sagittal{i}=distances_all{i}(isSagittal{i});
  corrCoeff_sagittal{i}=corrCoeff_all{i}(isSagittal{i});
  % obtain axial info
  distances_axial{i}=distances_all{i}(isAxial{i});
  corrCoeff_axial{i}=corrCoeff_all{i}(isAxial{i});
  % obtain coronal info
  distances_coronal{i}=distances_all{i}(isCoronal{i});
  corrCoeff_coronal{i}=corrCoeff_all{i}(isCoronal{i});
end
if scaledDistance
  str=fullfile('Matlab_variables','directionalityData_scaled.mat');
else
  str=fullfile('Matlab_variables','directionalityData.mat');
end
save(str,'isCoronal','isAxial','isSagittal',...
        'distances_sagittal','corrCoeff_sagittal',...
        'distances_axial','corrCoeff_axial',...
        'distances_coronal','corrCoeff_coronal')
end
