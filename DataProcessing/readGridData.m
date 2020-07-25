function readGridData(timePointNow,procParams)
% Retrieve current default processing parameters:
if nargin < 2
    procParams = GiveMeDefaultParams();
end

%-------------------------------------------------------------------------------
% Set up time points:
fileTimePoints = GiveMeParameter('fileTimePoints');
timePoints = GiveMeParameter('timePoints');
timePointIndex = find(strcmp(timePointNow,timePoints)); % match index to the chosen timepoint
sizeGrids = GiveMeParameter('sizeGrids');

%-------------------------------------------------------------------------------
%% Specify directories:
% Location of saved API gene expression data expressed in a cell
expression_loc = fullfile('Data','API','GridData',fileTimePoints{timePointIndex});


A = dir(expression_loc);
% remove hidden files
A = A(arrayfun(@(A) A.name(1), A) ~= '.');
numGenes = length(A);


% Initialize variables
energyGrids = cell(numGenes,1);
% Store IDs of each gene imported
geneIDInfo = zeros(numGenes,1);

% Store original directory and move to new directory (necessitated by
% filepath problems)
currentFolder = pwd;
cd(expression_loc);

%-------------------------------------------------------------------------------
h = waitbar(0,sprintf('Compiling energy grid for %s...',timePointNow));
%-------------------------------------------------------------------------------
for j = 1:numGenes

    fileStr = fullfile(A(j).name,'energy.raw');

    % ENERGY = 3-D matrix of expression energy grid volume
    % load files
    fid = fopen(fileStr, 'r', 'l' );
    energyGrids{j} = fread(fid,prod(sizeGrids.(timePoints{timePointIndex})),'float');
    fclose(fid);
    energyGrids{j} = reshape(energyGrids{j},sizeGrids.(timePoints{timePointIndex}));

    waitbar(j/numGenes)
end
close(h)

% return back to base directory
cd(currentFolder);
%-------------------------------------------------------------------------------
%% SAVE
% Gridded expression energy data:
cellTypeStr = GiveMeFileName(procParams.thisCellType);
fileOut = sprintf('energyGrids%s_%s.mat',cellTypeStr,timePoints{timePointIndex});
fileName = fullfile('Matlab_variables',fileOut);
save(fileName,'energyGrids','geneIDInfo','-v7.3')
fprintf(1,'Saved processed energy grid information to ''%s''.\n',fileName);

% % Gene ID for each grid:
% if strcmp(thisCellType,'allCellTypes')
%   var_name2=strcat('geneIDInfo_',timePoints{timePointIndex},'.mat');
%   str=fullfile('Matlab_variables',var_name2);
%   save(str,'geneIDInfo')

end
