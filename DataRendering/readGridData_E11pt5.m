%% load the files
%  grid volume size
tic

% user input the value of i (1=E11.5; 2=E13.5; 3=E15.5; 4=E18.5; 5=P4;
% 6=P14; 7=P28)
i=7;
% user input: current time point
timePointNow={'P28'};


fileTimePoints={'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'};
sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
% resolutionGrid=struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,...
%     'P14',200,'P28',200);

str=strcat('/projects/kg98/Gladys/API data/GridData/',fileTimePoints{i});
A=dir(str);
% remove hidden files
A=A(arrayfun(@(A) A.name(1), A) ~= '.');
% initialize
energyGrids=cell(length(A),1);
timePointInfo=cell(length(A),1);
geneIDInfo=zeros(length(A),1);

h = waitbar(0,'Compiling energy grid...');
steps=length(A);

for j=1:length(A)
    fileStr=strcat(A(j).name,'/','energy.raw');
    % ENERGY = 3-D matrix of expression energy grid volume
    fid = fopen(fileStr, 'r', 'l' );
    energyGrids{j} = fread( fid, prod(sizeGrids.(timePoints{i})), 'float' );
    fclose( fid );
    energyGrids{j} = reshape(energyGrids{j},sizeGrids.(timePoints{i}));
    infoStr=strsplit(A(j).name,'_');
    timePointInfo{j}=infoStr{1};
    geneIDInfo(j)=str2double(infoStr{2});
    waitbar(j/steps)
end
close(h)
%%
cd '/scratch/kg98/Gladys'
str=strcat('energyGrids_',timePoints{i},'.mat');
save(str,'energyGrids','-v7.3')
str=strcat('timePointInfo_',timePoints{i},'.mat');
save(str,'timePointInfo')
str=strcat('geneIDInfo_',timePoints{i},'.mat');
save(str,'geneIDInfo')

toc