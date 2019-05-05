function makeBinnedData_direction(numData,numThresholds,scaledDistance,thisDirection)
if scaledDistance
  if strcmp(thisDirection,'sagittal')
    load('directionalityData_scaled.mat','distances_sagittal','corrCoeff_sagittal');
  elseif strcmp(thisDirection,'coronal')
    load('directionalityData_scaled.mat','distances_coronal','corrCoeff_coronal');
  elseif strcmp(thisDirection,'axial')
    load('directionalityData_scaled.mat','distances_axial','corrCoeff_axial');
  end
else
  if strcmp(thisDirection,'sagittal')
    load('directionalityData.mat','distances_sagittal','corrCoeff_sagittal');
  elseif strcmp(thisDirection,'coronal')
    load('directionalityData.mat','distances_coronal','corrCoeff_coronal');
  elseif strcmp(thisDirection,'axial')
    load('directionalityData.mat','distances_axial','corrCoeff_axial');
  end
end
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

% Bin the data
if strcmp(thisDirection,'sagittal')
  [~,~,xPlotDataAll,yPlotDataAll] = plotBinning(distances_sagittal,...
                                                corrCoeff_sagittal,...
                                                numThresholds,false);
elseif strcmp(thisDirection,'coronal')
  [~,~,xPlotDataAll,yPlotDataAll] = plotBinning(distances_coronal,...
                                                corrCoeff_coronal,...
                                                numThresholds,false);
elseif strcmp(thisDirection,'axial')
  [~,~,xPlotDataAll,yPlotDataAll] = plotBinning(distances_axial,...
                                                corrCoeff_axial,...
                                                numThresholds,false);
end
% save variable
if scaledDistance
  str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
              'numThresholds','_',num2str(numThresholds),'_',thisDirection,'_scaled',...
              '_goodGeneSubset','.mat'));
else
  str=fullfile('Matlab_variables',strcat('binnedData_NumData_',num2str(numData),'_',...
              'numThresholds','_',num2str(numThresholds),'_',thisDirection,...
              '_goodGeneSubset','.mat'));
end
save(str,'xPlotDataAll','yPlotDataAll','numThresholds');
end
