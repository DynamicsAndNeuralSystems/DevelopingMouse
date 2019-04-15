%% user input 
% user input folder location of annotation files downloaded from API
gridAnno_loc='D:\Data\DevelopingMousePhase2\API-gridAnnotation';
% user input folder location of gene expression data downloaded from API
expression_loc='D:\Data\DevelopingAllenMouseAPI-master\API data\GridData';
% user input where to save created matlab variable
folder_save='D:\Data\DevelopingMousePhase2\makeAnnotationGrid';
%% load the files
whatData={'energy'};
% obtain the timepoint names
A=dir(expression_loc);
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
energyGrids=cell(length(A),1);

timePointInfo=cell(length(A),1);
geneIDInfo=cell(length(A),1);
annotationGrids=cell(length(A),1);
tic

for i=1:length(A) % for each time point%
    gridFileStr=strcat(gridAnno_loc,'\',timePoints{i},...
        '_DevMouse2012_gridAnnotation\gridAnnotation.raw');
    fid = fopen(gridFileStr, 'r', 'l' );
    annotationGrids{i} = fread( fid, prod(sizeGrids.(timePoints{i})), 'uint32' );
    fclose( fid );
    annotationGrids{i} = reshape(annotationGrids{i},sizeGrids.(timePoints{i}));
    isNotAnno=annotationGrids{i}==0;
end
toc
%% save variables
str=strcat(folder_save,'\','annotationGrids.mat');
save(str,'annotationGrids')