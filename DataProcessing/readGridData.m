function readGridData(timePointNow,useGoodGeneSubset,thisCellType)

%%
fileTimePoints=GiveMeParameter('fileTimePoints');
timePoints=GiveMeParameter('timePoints');
timePointIndex=GiveMeParameter('timePointIndex'); %match index to the chosen timepoint
sizeGrids = GiveMeParameter('sizeGrids');

%% Specify directories
% Location of saved API gene expression data expressed in a cell
expression_loc = fullfile('Data','API','GridData',fileTimePoints{timePointIndex});

if strcmp(thisCellType,'allCellTypes')
  if useGoodGeneSubset
    load('goodGeneSubset.mat','goodGeneSubset');
    numGenes = length(goodGeneSubset);
  else
    A = dir(expression_loc);
    % remove hidden files
    A = A(arrayfun(@(A) A.name(1), A) ~= '.');
    % So now each file is a gene corresponding to this time point
    numGenes = length(A);
  end
else
  load('enrichedGenes.mat','enrichedGenes');
  numGenes = length(enrichedGenes.(thisCellType).ID)
end
% initialize variables
energyGrids = cell(numGenes,1);
geneIDInfo = zeros(numGenes,1); % Stores IDs of each gene imported

% store original directory and move to new directory (necessitated by
% filepath problems)
currentFolder = pwd;
cd(expression_loc);

h = waitbar(0,'Compiling energy grid...');
steps = length(numGenes);
%%
for j=1:numGenes
    if strcmp(thisCellType,'allCellTypes')
      if useGoodGeneSubset
        fileStr = fullfile(sprintf('%s_%s',fileTimePoints{timePointIndex},...
                          num2str(goodGeneSubset{j})),'energy.raw');
      else
        fileStr = fullfile(A(j).name,'energy.raw');
      end
    else
      fileStr = fullfile(sprintf('%s_%s',fileTimePoints{timePointIndex},...
                  num2str(enrichedGenes.(thisCellType).ID(j))),'energy.raw');
    end
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
cellTypeStr = GiveMeFileName(thisCellType);
if (useGoodGeneSubset & strcmp(thisCellType,'allCellTypes'))
  var_name1 = sprintf('energyGrids_goodGeneSubset_%s.mat',timePoints{timePointIndex});
else
  var_name1 = sprintf('energyGrids%s_%s.mat',cellTypeStr,timePoints{timePointIndex});
end
str=fullfile('Matlab_variables',var_name1);
save(str,'energyGrids','-v7.3')
% Gene ID for each grid:
if strcmp(thisCellType,'allCellTypes')
  var_name2=strcat('geneIDInfo_',timePoints{timePointIndex},'.mat');
  str=fullfile('Matlab_variables',var_name2);
  save(str,'geneIDInfo')
end

end
