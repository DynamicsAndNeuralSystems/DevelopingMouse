function readGridData(whatTimePointNow)

%%
fileTimePoints={'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'};
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
timePointIndex=find(cellfun(@(c)strcmp(whatTimePointNow,c),timePoints)); %match index to the chosen timepoint
sizeGrids = struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);

%% Specify directories
% Location of saved API gene expression data expressed in a cell
expression_loc = fullfile('Data','API','GridData',fileTimePoints{timePointIndex});

%%
A = dir(expression_loc);
% remove hidden files
A = A(arrayfun(@(A) A.name(1), A) ~= '.');

% So now each file is a gene corresponding to this time point
numGenes = length(A);
% initialize variables
energyGrids = cell(numGenes,1);
geneIDInfo = zeros(numGenes,1); % Stores IDs of each gene imported

% store original directory and move to new directory (necessitated by
% filepath problems)
currentFolder = pwd;
cd(expression_loc);

h = waitbar(0,'Compiling energy grid...');
%%
for j=1:numGenes
    fileStr=fullfile(A(j).name,'energy.raw');
    % ENERGY = 3-D matrix of expression energy grid volume
    % load files
    fid = fopen(fileStr, 'r', 'l' );
    energyGrids{j} = fread(fid,prod(sizeGrids.(timePoints{timePointIndex})),'float');
    fclose(fid);
    energyGrids{j} = reshape(energyGrids{j},sizeGrids.(timePoints{timePointIndex}));
    infoStr=strsplit(A(j).name,'_');
    geneIDInfo(j)=str2double(infoStr{2});
    waitbar(j/steps)
end
close(h)

%% redirect to home directory
cd(currentFolder);

%% SAVE
% Gridded expression energy data:
var_name1=strcat('energyGrids_',timePoints{timePointIndex},'.mat');
str=fullfile('Matlab_variables',var_name1);
save(str,'energyGrids','-v7.3')
% Gene ID for each grid:
var_name3=strcat('geneIDInfo_',timePoints{timePointIndex},'.mat');
str=fullfile('Matlab_variables',var_name3);
save(str,'geneIDInfo')

end
