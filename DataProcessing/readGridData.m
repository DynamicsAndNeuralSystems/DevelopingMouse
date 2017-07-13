% read in the raw files one by one, registering the 3D position, geneID and expression value
%------------
% Download and unzip the energy grid file for P4 Rora Pdyn SectionDataSet
% -----------
sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
%% load the files
%  grid volume size
sizeGrid = [70,75,40];
A=dir('D:\Data\DevelopingAllenMouseAPI-master\API data\GridData');
% remove hidden files
A=A(arrayfun(@(A) A.name(1), A) ~= '.');
% initialize
energyGrids=cell(length(A),1);
timePointInfo=cell(length(A),1);
geneIDInfo=zeros(length(A),1);
for i=1:length(A)
    fileStr=strcat(A(i).name,'/','energy.raw');
    % ENERGY = 3-D matrix of expression energy grid volume
    fid = fopen(fileStr, 'r', 'l' );
    energyGrids{i} = fread( fid, prod(sizeGrid), 'float' );
    fclose( fid );
    energyGrids{i} = reshape(energyGrids{i},sizeGrid);
    infoStr=strsplit(A(i).name,'_');
    timePointInfo{i}=infoStr{1};
    geneIDInfo(i)=str2double(infoStr{2});
end

