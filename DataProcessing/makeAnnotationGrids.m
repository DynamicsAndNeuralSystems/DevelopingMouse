function makeAnnotationGrids()
% <><><>><><><><>

gridAnno_loc = fullfile('Data','API','AnnotationData');
timePoints = GiveMeParameter('timePoints');
sizeGrids = GiveMeParameter('sizeGrids');

annotationGrids = cell(length(timePoints),1);
for i = 1:length(timePoints) % for each time point%
    theGridFile = fullfile(gridAnno_loc,sprintf('%s_DevMouse2012_gridAnnotation',timePoints{i}),...
                            'gridAnnotation.raw');
    fprintf(1,'Loading data from %s\n',theGridFile);
    fid = fopen(theGridFile,'r','l');
    if fid==-1
        error('Grid annotation file: ''%s'' not found',theGridFile);
    end
    annotationGrids{i} = fread(fid, prod(sizeGrids.(timePoints{i})), 'uint32');
    fclose(fid);
    annotationGrids{i} = reshape(annotationGrids{i},sizeGrids.(timePoints{i}));
end

%% save variables
fileOut = fullfile('Matlab_variables','annotationGrids.mat');
save(fileOut,'annotationGrids')

fprintf(1,'Annotation grids across %u time points read and saved to %s\n',length(timePoints),fileOut);

end
