function [structures,Exp,geneEntrez,geneList,timePoints] = LoadData_SDK(filterHow,whatNorm,keepP56)
% Reads in data from the SDK expression csv files downloaded from Allen using
% python scripts, and outputs the structures and expression data, etc. as
% Matlab variables

%-------------------------------------------------------------------------------
% Check inputs:
%-------------------------------------------------------------------------------

% How to filter genes:
% 'mulitple' (at least 3 datapoints), 'any' (at least one datapoint)
if nargin < 1
    filterHow = 'multiple';
end
if nargin < 2
    whatNorm = 'scaledSigmoid'; % 'maxmin', 'scaledSigmoid'
end
% By default don't keep the final adult time point
if nargin < 3
    keepP56 = 0;
end

%-------------------------------------------------------------------------------
% Specify structures:
%-------------------------------------------------------------------------------
% Future vermis = isA and isR+r1R
% Future hemisphere = r1A
structures = {'r1A','r1R','isA','isR','vermis2','vermis3'};
ownStructure = [1,1,1,1,0,0]; % specifies if each structure is it's own entity (vermis a grouped object)
% (needs to have all ones first)
numStructures = length(structures);

%-------------------------------------------------------------------------------
% Load data:
%-------------------------------------------------------------------------------
expMeasure = {'Energy','Density'};

% Import expression data into the Matlab Exp structure
Exp = struct();
for i = 1:length(expMeasure)
    Exp.(expMeasure{i}).raw = cell(numStructures,1);
    for j = 1:numStructures
        if ownStructure(j)
            fileName = sprintf('SDK_Expression%s_%s.csv',expMeasure{i},structures{j});
            Exp.(expMeasure{i}).raw{j} = importfile1(fileName);
        else
            switch structures{j}
            case 'vermis2'
                % Add 'vermis2' as the mean across isA (3), isR (4)
                Exp.(expMeasure{i}).raw{j} = MeanCellMatrices(Exp.(expMeasure{i}).raw(3:4));
            case 'vermis3'
                % Add 'vermis3' as the mean across r1R (2), isA (3), isR (4)
                Exp.(expMeasure{i}).raw{j} = MeanCellMatrices(Exp.(expMeasure{i}).raw(2:4));
            end
        end
    end
end

geneEntrez = importEntrezIDs('SDK_geneEntrez.csv');
geneList = importGeneAbb('SDK_geneAbbreviations.csv');
timePoints = importTime('SDK_timePoints.csv');

numGenes = length(geneList);

%-------------------------------------------------------------------------------
% Filter out P56?
%-------------------------------------------------------------------------------
if ~keepP56
    warning('Removing P56')
    % Ok so for each Energy and Density, for the raw field we have a cell with a
    % component for each structure: time x gene
    % We want to get the time Points
    isP56 = strcmp(timePoints,'P56');
    for i = 1:length(expMeasure)
        for j = 1:numStructures
            Exp.(expMeasure{i}).raw{j} = Exp.(expMeasure{i}).raw{j}(~isP56,:);
        end
    end
    timePoints = timePoints(~isP56);
end

%-------------------------------------------------------------------------------
% Filter on expression energy
%-------------------------------------------------------------------------------
% We want to keep genes that have good values in the structures over time
hasData = zeros(numGenes,sum(ownStructure)); % not for grouped data in vermis
switch filterHow
case 'any' % you want at least one data point
    for i = 1:numStructures
        if ownStructure(i)
            hasData(:,i) = ~all(isnan(Exp.Energy.raw{i}));
        end
    end
case 'multiple' % you want at least three data points
    for i = 1:numStructures
        if ownStructure(i)
            hasData(:,i) = sum(~isnan(Exp.Energy.raw{i})) > 2;
        end
    end
end

% At least one of the key structures meets the inclusion criterion:
hasData = (sum(hasData,2) > 0);

% Now filter gene list based on these criteria (for all structures)
fprintf(1, 'Filtering gene list from %u down to %u using ''%s''\n',numGenes,sum(hasData),filterHow);
geneList = geneList(hasData);
geneEntrez = geneEntrez(hasData);
numGenes = length(geneList);

for i = 1:length(expMeasure)
    fieldName = expMeasure{i};
    for j = 1:numStructures
        Exp.(fieldName).raw{j} = Exp.(fieldName).raw{j}(:,hasData);
    end
end

%-------------------------------------------------------------------------------
% Normalize expression data
%-------------------------------------------------------------------------------

%----Save as norm field for each structure and gene separately
for g = 1:length(expMeasure)
    Exp.(expMeasure{g}).norm = cell(numStructures,1);
    for i = 1:numStructures
        Exp.(expMeasure{g}).norm{i} = BF_NormalizeMatrix(Exp.(expMeasure{g}).raw{i},whatNorm);
    end

    % % Add the vermis as the mean across r1R,isA,isR
    % if vermisNormAsMean
    %     Exp.(expMeasure{g}).norm{numStructures+1} = MeanCellMatrices(Exp.(expMeasure{g}).norm(2:4));
    % else
    %     % Treat it like any other structure
    %     Exp.(expMeasure{g}).norm{numStructures+1} = BF_NormalizeMatrix(Exp.(expMeasure{g}).raw{i},whatNorm);
    % end
end

%----Save as normGene field for each gene separately (relative to all structures and time points)
% 7 or 8 (with P56) [time] x 2104 [gene] x 5 [structure]
% allRawData = MakeMatrix(Exp.(expMeasure{g}).raw);
allRawData = vertcat(Exp.Energy.raw{1:4}); % each gene across all time and structures
meanTime = nanmean(allRawData,1);
stdTime = nanstd(allRawData,1);
sigmoidNorm = @(x,ind) 1./(1 + exp(-(x-meanTime(ind))/stdTime(ind)));

for g = 1:length(expMeasure)
    Exp.(expMeasure{g}).normGene = cell(numStructures,1);
    for i = 1:numStructures
        Exp.(expMeasure{g}).normGene{i} = zeros(size(Exp.(expMeasure{g}).raw{i}));
        for j = 1:numGenes
            Exp.(expMeasure{g}).normGene{i}(:,j) = sigmoidNorm(Exp.(expMeasure{g}).raw{i}(:,j),j);
        end
    end

    % Add the vermis as the mean across r1R,isA,isR
    % <<NOT IMPLEMENTED YET; always done as above>>
end

%-------------------------------------------------------------------------------
function matrixMean = MeanCellMatrices(Xcell)
    Xmatrix = MakeMatrix(Xcell);
    matrixMean = mean(Xmatrix,3);
end
%-------------------------------------------------------------------------------
function Xmatrix = MakeMatrix(Xcell)
    [x,y] = size(Xcell{1});
    Xmatrix = zeros(x,y,length(Xcell));
    for k = 1:length(Xcell)
        Xmatrix(:,:,k) = Xcell{k};
    end
end
%-------------------------------------------------------------------------------

end
