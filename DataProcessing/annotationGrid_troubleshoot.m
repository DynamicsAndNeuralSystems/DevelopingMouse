% troubleshoot annotation grid
%% load the files
whatData={'energy'};
% obtin the timepoint names
A=dir('/home/hyglau/kg98/Gladys/API data/GridData');
A=A(arrayfun(@(A) A.name(1), A) ~= '.'); % don't keep hidden files
% sort file names in correct time point order
names=cell(length(A),1);
for k=1:length(A)
    names{k}=A(k).name;
end
[~,nameOrder]=sort_nat(names);
A=A(nameOrder);

sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
%%
% initialize
% energyGrids=cell(length(A),1);
% %energyGridsMat=cell(length(A),1);
% timePointInfo=cell(length(A),1);
% geneIDInfo=cell(length(A),1);
annotationGrids=cell(length(A),1);
tic
% h=waitbar(0,'Computing time point data...');
% steps=length(A);
%folderDir=cell(length(A),1);
for i=2%:length(A) % for each time point%
    folderDir=dir(strcat('/home/hyglau/kg98/Gladys/API data/GridData/',A(i).name));
    folderDir=folderDir(arrayfun(@(folderDir) folderDir.name(1), folderDir) ~= '.');
%     timePointInfo{i}=cell(length(folderDir),1);
%     geneIDInfo{i}=cell(length(folderDir),1);
%     energyGrids{i}=cell(length(folderDir),1);
    % load the grid annotation for the timepoint
    gridFileStr=strcat('/home/hyglau/kg98/Gladys/API data/LinkDownload/',timePoints{i},...
        '_DevMouse2012_gridAnnotation/gridAnnotation.raw');
    fid = fopen(gridFileStr, 'r', 'l' );
    annotationGrids{i} = fread( fid, prod(sizeGrids.(timePoints{i})), 'float' );
    fclose( fid );
    annotationGrids{i} = reshape(annotationGrids{i},sizeGrids.(timePoints{i}));
    
    % extract the ID of the annotated structures (for querying their acronyms)
%     isAnno=(annotationGrids{i}>0);
%     annotationsClean=annotationGrids{i};
%     annoID_E13pt5=unique(annotationsClean(isAnno));
%     cd '/projects/kg98/Gladys/Git/Troubleshooting/readGridData_troubleshootE13pt5_var'
% 
%     dlmwrite('annoID_E13pt5.csv', annoID_E13pt5, 'delimiter', ',', 'precision', 10); 

end
toc
