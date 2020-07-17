function DownloadGridAnnotations()
% Download grid annotation files from the 2012 DevMouse Allen site
%-------------------------------------------------------------------------------

timePoints = GiveMeParameter('timePoints');
for i = 1:length(timePoints)
    url = sprintf('http://download.alleninstitute.org/informatics-archive/current-release/mouse_annotation/%s_DevMouse2012_annotation.zip',timePoints{i});
    fileName = fullfile('Data','API','AnnotationData',sprintf('%s_DevMouse2012_gridAnnotation.zip',timePoints{i}));
    websave(fileName,url);
    fprintf(1,'%u/%u: Saved annotation grid data to %s\n',i,length(timePoints),fileName);
end

end
