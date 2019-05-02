% create correlation coefficient and distances
function [distances_all,corrCoeff_all]=makeSpatialData_noDirection(whatNumData,...
                                                                  useGoodGeneSubset)
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  distances_all=cell(length(timePoints),1);
  corrCoeff_all=cell(length(timePoints),1);
  for i=1:length(timePoints)
    if useGoodGeneSubset
      filename=strcat('voxelGeneCoexpression_goodGeneSubset','_',timePoints{i},'.mat');
    else
      filename=strcat('voxelGeneCoexpression','_',timePoints{i},'.mat');
    end
    load(filename);
    [distances_all{i},corrCoeff_all{i}]=sampleGridData_noDirection(voxGeneMat,...
                                                                    coOrds,...
                                                                    whatNumData,...
                                                                    timePoints{i});
  end
  if useGoodGeneSubset
    str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                        num2str(whatNumData),'_goodGeneSubset_noDirection','.mat'));
  else
    str=fullfile('Matlab_variables',strcat('spatialData_NumData','_',...
                                          num2str(whatNumData),'_noDirection','.mat'));
  end
  save(str,'distances_all','corrCoeff_all')
end
