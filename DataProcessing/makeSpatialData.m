% create correlation coefficient and distances
function [distances_all,corrCoeff_all,angle_coronal_all,angle_axial_all,angle_sagittal_all]=makeSpatialData(whatNumData,useGoodGeneSubset,thisBrainDiv,scaledDistance)
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  distances_all=cell(length(timePoints),1);
  corrCoeff_all=cell(length(timePoints),1);
  angle_coronal_all=cell(length(timePoints),1);
  angle_axial_all=cell(length(timePoints),1);
  angle_sagittal_all=cell(length(timePoints),1);
  for i=1:length(timePoints)
    if (i==1 & strcmp(thisBrainDiv,'midbrain'))
      numData=587; % only 587 voxels are available in the midbrain in E11.5
    else
      numData=whatNumData;
    end
    if useGoodGeneSubset
      if strcmp(thisBrainDiv,'wholeBrain')
        filename=strcat('voxelGeneCoexpression_goodGeneSubset','_',timePoints{i},'.mat');
      else
        filename=strcat('voxelGeneCoexpression_',thisBrainDiv,'_','goodGeneSubset','_',...
                        timePoints{i},'.mat');
      end
    else
      if strcmp(thisBrainDiv,'wholeBrain')
        filename=strcat('voxelGeneCoexpression','_',timePoints{i},'.mat');
      else
        filename=strcat('voxelGeneCoexpression_',thisBrainDiv,'_',timePoints{i},'.mat');
      end
    end
    load(filename);
    if scaledDistance
      [distances_all{i},...
      corrCoeff_all{i},...
      angle_coronal_all{i},...
      angle_axial_all{i},...
      angle_sagittal_all{i}]=sampleGridData(voxGeneMat,coOrds,numData,timePoints{i},true);
    else
      [distances_all{i},...
      corrCoeff_all{i},...
      angle_coronal_all{i},...
      angle_axial_all{i},...
      angle_sagittal_all{i}]=sampleGridData(voxGeneMat,coOrds,numData,timePoints{i},false);
    end
  end
  if useGoodGeneSubset
    if strcmp(thisBrainDiv,'wholeBrain')
      if scaledDistance
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                          num2str(numData),'_scaled','_goodGeneSubset','.mat'));
      else
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                        num2str(numData),'_goodGeneSubset','.mat'));
      end
    else
      if scaledDistance
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                        num2str(numData),'_',thisBrainDiv,'_scaled','_goodGeneSubset','.mat'));
      else
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                        num2str(numData),'_',thisBrainDiv,'_goodGeneSubset','.mat'));
      end
    end
  else
    if strcmp(thisBrainDiv,'wholeBrain')
      if scaledDistance
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                          num2str(numData),'_scaled','.mat'));
      else
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                          num2str(numData),'.mat'));
      end
    else
      if scaledDistance
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                            num2str(numData),'_',thisBrainDiv,'_scaled','.mat'));
      else
        str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                          num2str(numData),'_',thisBrainDiv,'.mat'));
      end
    end
  end
  save(str,'distances_all','corrCoeff_all','angle_coronal_all','angle_axial_all','angle_sagittal_all')
end
% makeCorrCoeffAll_distancesAll('voxelGeneCoexpression_all','wholeBrain')
% makeCorrCoeffAll_distancesAll('voxelGeneCoexpression_all_subsetGenes','wholeBrain')
% %---------------------------------------------------------------------
% % initialize and load variables
% %---------------------------------------------------------------------
% timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% load('voxelGeneCoexpression_all.mat') % contains 'voxGeneMat_all','distMat_all','dataIndSelect_all'
% %
% % initialize
% distances_all = cell(length(timePoints),1);
% corrCoeff_all = cell(length(timePoints),1);
% distances_all_scaled = cell(length(timePoints),1);
% %---------------------------------------------------------------------
% % Plot gene coexpression against distance
% %---------------------------------------------------------------------
% % create variables and plot
% for i = 1:length(timePoints)
%     [distances_all{i},corrCoeff_all{i}]=computeCorrCoeff_distances(...
%                                         voxelGeneCoexpression_all.wholeBrain.voxGeneMat_all{i},...
%                                         voxelGeneCoexpression_all.wholeBrain.distMat_all{i},...
%                                         voxelGeneCoexpression_all.wholeBrain.dataIndSelect_all{i});
%     % create another distance cell normalized by max distance
%     distances_all_scaled{i}=distances_all{i}/max(distances_all{i});
%     % saveas(f,str)
% end
% %%
% %---------------------------------------------------------------------
% % save variables
% %---------------------------------------------------------------------
% str=fullfile('Matlab_variables','corrCoeffAll_distancesAll.mat');
% save(str, 'distances_all', 'corrCoeff_all', 'distances_all_scaled');
