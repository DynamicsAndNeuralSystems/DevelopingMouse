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

if procParams.usePersistentGenes
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

    if strcmp(timePointNow,'P56') % cater for duplicate experiments for a gene in P56
      dataInfo = arrayfun(@(A) split(A.name,'_'),A,'UniformOutput',false);
      % extract the gene IDs
      gene_ID = zeros(length(dataInfo),1);
      for i = 1:length(dataInfo)
        gene_ID(i) = str2double(dataInfo{i}(2));
      end
      % indices to unique gene IDs
      [~,uniqueIx,~] = unique(gene_ID,'stable');
      Ix = [1:numel(gene_ID)];
      % duplicate indices
      [~,dupIx] = setdiff(Ix,uniqueIx,'stable'); %gets index of the first duplicate
      % find the duplicate grid matrices
      dupGroups = cell(length(dupIx),1);
      for i = 1:length(dupIx)
        dupGroups{i} = find(gene_ID(dupIx(i)) == gene_ID);
      end
      [dupGroups,~,~] = uniquecell(dupGroups); % keep unique dupGroups only

      % So now each file is a gene corresponding to this time point
      numData = length(A);
    else
      numData = length(A);
    end
end

% Initialize variables
energyGrids = cell(numData,1);
% Store IDs of each gene imported
geneIDInfo = zeros(numData,1);

% Store original directory and move to new directory (necessitated by
% filepath problems)
currentFolder = pwd;
cd(expression_loc);

%-------------------------------------------------------------------------------
h = waitbar(0,sprintf('Compiling energy grid for %s...',timePointNow));
%-------------------------------------------------------------------------------
for j = 1:numData
    if procParams.usePersistentGenes
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
    if procParams.usePersistentGenes
        if strcmp(procParams.thisCellType,'allCellTypes')
            geneIDInfo(j) = goodGeneSubset{j};
        else
            geneIDInfo(j) = (enrichedGenes.(procParams.thisCellType).ID(j));
        end
    else
        infoStr = strsplit(A(j).name,'_');
        geneIDInfo(j) = str2double(infoStr{2});
    end
    waitbar(j/numData)
end
close(h)

% return back to base directory
cd(currentFolder);
if strcmp(timePointNow,'P56')
  % average duplicate experiments (i.e. experiments for same genes)
  meanGrid = cell(length(dupGroups),1);
  for i = 1:length(dupGroups)
    meanGrid{i} = mean(cat(4,energyGrids{dupGroups{i}}),4);
  end
  % read all the grids into a cell
  energyGridsMean = cell(length(uniqueIx),1);
  meanGridCounter = 1; % counts mean Grid (duplicate experiments)
  indexCounter = 1; % counts numData
  uniqueIxCounter = 1; % counts unique index

  while indexCounter <= length(numData)
    if indexCounter == uniqueIx(uniqueIxCounter) % unique experiment
      energyGridsMean{uniqueIxCounter} = energyGrids{indexCounter};
      uniqueIxCounter = uniqueIxCounter + 1;
      indexCounter = indexCounter + 1;
    else
      energyGridsMean{uniqueIxCounter} = meanGrid{meanGridCounter}; % averaged experiments
      indexCounter = indexCounter + length(dupGroups{meanGridCounter});
      meanGridCounter = meanGridCounter + 1;
    end
  end
  energyGrids = energyGridsMean;
end
fprintf(1,'indexCounter=%d\n',indexCounter);
fprintf(1,'uniqueIxCounter=%d\n',uniqueIxCounter);
fprintf(1,'meanGridCounter=%d\n',meanGridCounter);
%-------------------------------------------------------------------------------
%% SAVE
% Gridded expression energy data:
cellTypeStr = GiveMeFileName(procParams.thisCellType);
if (procParams.usePersistentGenes & strcmp(procParams.thisCellType,'allCellTypes'))
    fileOut = sprintf('energyGrids_goodGeneSubset_%s.mat',timePoints{timePointIndex});
else
    fileOut = sprintf('energyGrids%s_%s.mat',cellTypeStr,timePoints{timePointIndex});
end
fileName = fullfile('Matlab_variables',fileOut);
save(fileName,'energyGrids','geneIDInfo','-v7.3')
fprintf(1,'Saved processed energy grid information to ''%s''.\n',fileName);

% % Gene ID for each grid:
% if strcmp(thisCellType,'allCellTypes')
%   var_name2=strcat('geneIDInfo_',timePoints{timePointIndex},'.mat');
%   str=fullfile('Matlab_variables',var_name2);
%   save(str,'geneIDInfo')

end
