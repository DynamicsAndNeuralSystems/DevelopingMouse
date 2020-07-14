function createSpatialData(procParams)
% create distance and correlation distances, and angles that voxel pairs
% make with the axes for different brain divisions, cell types, using good gene subset, with or without
% directions

scaledDistance = GiveMeParameter('scaledDistance');

for k = 1:length(scaledDistance)
    makeSpatialData(numData,thisBrainDiv,scaledDistance{k},thisCellType,withDirection);
end

% create distances (unscaled) and correlation from good genes
% for j=1:length(brainDivisions)
%     for k=1:length(scaledDistance)
%         for m=1:length(cellTypes)
%             [~,~,~,~,~] = makeSpatialData(numData,brainDivisions{j},...
%                                       scaledDistance{k},cellTypes{m},withDirection);
%         end
%     end
% end

end
