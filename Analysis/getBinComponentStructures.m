timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('spatialData_NumData_1000.mat');
load('dataDevMouse.mat');
numThresholds=30;
binsOfInterest=cell(length(timePoints),1);
regionsOfInterest=cell(length(timePoints),1);
% set the bins of interest
binsOfInterest{6}=[15 16 17 18 21];
binsOfInterest{7}=[8 9 11 28];

% make binned data
binnedDataCell_all=cell(length(timePoints),1);
binnedAnnotationCell_all=cell(length(timePoints),1);
for i=1:length(timePoints)
  f=figure('color','w','Position',get(0, 'Screensize'));
  [binnedDataCell_all{i},binnedAnnotationCell_all{i}]=makeBinnedData(distances_all{i},...
                                                                      corrCoeff_all{i},...
                                                                      numThresholds,...
                                                                      annotation_pair_all{i});
  % get the annotations in such bins
  if ~isempty(binsOfInterest{i})
    regionsOfInterest{i}=cell(length(binsOfInterest{i}),1);
    for j=1:length(binsOfInterest{i})
      [~,ia,ib]=intersect(binnedAnnotationCell_all{i}{j},dataDevMouse.(timePoints{i}).id,'stable');
      regionsOfInterest{i}{j}=dataDevMouse.(timePoints{i}).acronym(ib);
    end
  end
end
