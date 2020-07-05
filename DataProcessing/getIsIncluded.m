function [isIncluded] = getIsIncluded(thisBrainDiv,timePointNow)
  timePoints = GiveMeParameter('timePoints');
  timePointIndex = find(strcmp(timePointNow,timePoints)); %match index to the chosen timepoint
  % load variables
  load('annotationGrids.mat','annotationGrids')
  load('brainDivision.mat','brainDivision')

  if strcmp(thisBrainDiv,'wholeBrain')
      isIncluded=or(or(ismember(annotationGrids{timePointIndex},brainDivision.forebrain.ID),...
                        ismember(annotationGrids{timePointIndex},brainDivision.midbrain.ID)),...
                        ismember(annotationGrids{timePointIndex},brainDivision.hindbrain.ID));
  elseif strcmp(thisBrainDiv,'forebrain')
    isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.forebrain.ID);
  elseif strcmp(thisBrainDiv,'midbrain')
    isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.midbrain.ID);
  elseif strcmp(thisBrainDiv,'hindbrain')
    isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.hindbrain.ID);
  elseif strcmp(thisBrainDiv,'Dpallidum')
    isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.Dpallidum.ID);
  else
    error('Invalid brain division input')
  end
end
