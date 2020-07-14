function makeAnnotationGrids()
% <><><>><><><><>

gridAnno_loc = fullfile('Data','API','AnnotationData');
timePoints = GiveMeParameter('timePoints');
sizeGrids = GiveMeParameter('sizeGrids');

annotationGrids = cell(length(timePoints),1);
for i = 1:length(timePoints) % for each time point%
    gridFileStr = fullfile(gridAnno_loc,sprintf('%s_DevMouse2012_gridAnnotation',timePoints{i}),...
                            'gridAnnotation.raw');
    fid = fopen(gridFileStr,'r','l');
    annotationGrids{i} = fread(fid, prod(sizeGrids.(timePoints{i})), 'uint32');
    fclose(fid);
    annotationGrids{i} = reshape(annotationGrids{i},sizeGrids.(timePoints{i}));
end

%% save variables
str = fullfile('Matlab_variables','annotationGrids.mat');
save(str,'annotationGrids')

end
