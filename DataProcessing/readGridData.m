function readGridData(timePointNow,procParams)
% Retrieve current default processing parameters:
if nargin < 2
    procParams = GiveMeDefaultProcessingParams();
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

if procParams.useGoodGeneSubset
    load('goodGeneSubset.mat','goodGeneSubset');
    if ~strcmp(procParams.thisCellType,'allCellTypes')
        load('enrichedGenes.mat','enrichedGenes');
        numGenes = length(enrichedGenes.(procParams.thisCellType).ID);
    else
        numGenes = length(goodGeneSubset);
    end
else
    A = dir(expression_loc);
    % remove hidden files
    A = A(arrayfun(@(A) A.name(1), A) ~= '.');
    % So now each file is a gene corresponding to this time point
    numGenes = length(A);
end

% Initialize variables
energyGrids = cell(numGenes,1);
geneIDInfo = zeros(numGenes,1); % Stores IDs of each gene imported

% Store original directory and move to new directory (necessitated by
% filepath problems)
currentFolder = pwd;
cd(expression_loc);

%-------------------------------------------------------------------------------
h = waitbar(0,('Compiling energy grid for %s...',timePointNow));
%-------------------------------------------------------------------------------
for j=1:numGenes
    if procParams.useGoodGeneSubset
        if strcmp(procParams.thisCellType,'allCellTypes')
            fileStr = fullfile(sprintf('%s_%s',fileTimePoints{timePointIndex},...
                        num2str(goodGeneSubset{j})),'energy.raw');
        else
            fileStr = fullfile(sprintf('%s_%s',fileTimePoints{timePointIndex},...
                  num2str(enrichedGenes.(procParams.thisCellType).ID(j))),'energy.raw');
        end
    else
        fileStr = fullfile(A(j).name,'energy.raw');
    end
    % ENERGY = 3-D matrix of expression energy grid volume
    % load files
    fid = fopen(fileStr, 'r', 'l' );
    energyGrids{j} = fread(fid,prod(sizeGrids.(timePoints{timePointIndex})),'float');
    fclose(fid);
    energyGrids{j} = reshape(energyGrids{j},sizeGrids.(timePoints{timePointIndex}));
    if procParams.useGoodGeneSubset
        if strcmp(procParams.thisCellType,'allCellTypes')
            geneIDInfo(j) = goodGeneSubset{j};
        else
            geneIDInfo(j) = (enrichedGenes.(procParams.thisCellType).ID(j));
        end
    else
        infoStr = strsplit(A(j).name,'_');
        geneIDInfo(j) = str2double(infoStr{2});
    end
    waitbar(j/numGenes)
end
close(h)

% return back to base directory
cd(currentFolder);

%-------------------------------------------------------------------------------
%% SAVE
% Gridded expression energy data:
cellTypeStr = GiveMeFileName(procParams.thisCellType);
if (procParams.useGoodGeneSubset & strcmp(procParams.thisCellType,'allCellTypes'))
    fileOut = sprintf('energyGrids_goodGeneSubset_%s.mat',timePoints{timePointIndex});
else
    fileOut = sprintf('energyGrids%s_%s.mat',cellTypeStr,timePoints{timePointIndex});
end
fileName = fullfile('Matlab_variables',fileOut);
save(fileName,'energyGrids','-v7.3')
fprintf(1,'Saved processed energy grid information to %s\n',fileName);

% % Gene ID for each grid:
% if strcmp(thisCellType,'allCellTypes')
%   var_name2=strcat('geneIDInfo_',timePoints{timePointIndex},'.mat');
%   str=fullfile('Matlab_variables',var_name2);
%   save(str,'geneIDInfo')

end
