function [structures,Exp,geneEntrez,geneList,timePoints] = LoadData_SDK_full_data_level5(filterHow,whatNorm)
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

%-------------------------------------------------------------------------------
% Specify structures:
%-------------------------------------------------------------------------------

structures = {'r4B','POR','r3F','r10F','THyA','r1R','p2R','r4F','r7B','p1R',...
                'p1A','r1B','m1B','m2B','p3F','r5F','isA','r9F','p1B','r3R',...
                'm2F','r10B','r6R','r9A','r9R','r10R','POA','p3R','r6A','r4A',...
                'isB','m2R','p1F','m2A','r9B','r7R','isF','r8R','r6B','r8F','r8A',...
                'r4R','p2A','p3A','r3A','PHyB','m1R','r3B','THyF','p2F','THyB',...
                'p2B','r7F','r11R','r1A','r5B','p3B','r2A','r11A','r11B','isR',...
                'r7A','r2R','r6F','r11F','PHyA','r2F','r5A','r5R','r8B','r10A',...
                'TelA','m1F','r1F','PHyF','m1A','r2B','TelR'};

%ownStructure = [ones(1,34),0,0]; % specifies if each structure is it's own entity (AON and COA consists of several structures)
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
            fileName = sprintf('SDK_Expression%s_%s.csv',expMeasure{i},structures{j});
            Exp.(expMeasure{i}).raw{j} = importfile2(fileName);
    end
end

geneEntrez = xlsread('SDK_geneEntrez.csv');
[~,geneList,~]  = xlsread('SDK_geneAbbreviations.csv');
[~,timePoints,~] = xlsread('SDK_timePoints.csv');

numGenes = length(geneList);

%-------------------------------------------------------------------------------
% Filter on expression energy
%-------------------------------------------------------------------------------
% We want to keep genes that have good values in the structures over time
hasData = zeros(numGenes,numStructures); % not for grouped data in vermis
switch filterHow
case 'any' % you want at least one data point
    for i = 1:numStructures
        hasData(:,i) = ~all(isnan(Exp.Energy.raw{i})); % a structure is dubbed 'hasData=1' if at least 1 gene has 1 data
    end
case 'multiple' % you want at least three data points
    for i = 1:numStructures
       hasData(:,i) = sum(~isnan(Exp.Energy.raw{i})) > 2; % a structure is dubbed 'hasData=1' if at least there are 3 data points
    end
end

% At least one of the key structures meets the inclusion criterion:
hasData = (sum(hasData,2) > 0); % returns a logical column vector, 1=gene has at least 1 structure fulfilling the criteria

% Now filter gene list based on these criteria (for all structures)
fprintf(1, 'Filtering gene list from %u down to %u using ''%s''\n',...
                numGenes,sum(hasData),filterHow);
geneList = geneList(hasData);
geneEntrez = geneEntrez(hasData);
numGenes = length(geneList);

for i = 1:length(expMeasure)
    fieldName = expMeasure{i};
    for j = 1:numStructures
        Exp.(fieldName).raw{j} = Exp.(fieldName).raw{j}(:,hasData); % only retain genes fulfilling criteria
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
allRawData = vertcat(Exp.Energy.raw{1:numStructures}); % each gene across all time and structures
meanTime = nanmean(allRawData,1); % take mean across time
stdTime = nanstd(allRawData,1); % take SD across time
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

%----Save as normStructure field for each gene separately (z score normalized across structures)
% 7 or 8 (with P56) [time] x 2104 [gene] x 5 [structure]
% allRawData = MakeMatrix(Exp.(expMeasure{g}).raw);
allRawData_structure = MakeMatrix(Exp.Energy.raw);
meanStructure = nanmean(allRawData_structure,3); % take mean across structure
stdStructure = zeros(size(Exp.Energy.raw{1}));

for i=1:length(timePoints)
    timeSlice=squeeze(allRawData_structure(i,:,:))'; % this is 2100 (genes) x 78 (structure)
    stdStructure(i,:)=nanstd(timeSlice);
end

for g = 1:length(expMeasure)
    Exp.(expMeasure{g}).normStructure = cell(numStructures,1);
    for i = 1:numStructures
        Exp.(expMeasure{g}).normStructure{i}=(Exp.(expMeasure{g}).raw{i}-meanStructure)./stdStructure;

    end

    % Add the vermis as the mean across r1R,isA,isR
    % <<NOT IMPLEMENTED YET; always done as above>>
end


%-------------------------------------------------------------------------------
function matrixMean = MeanCellMatrices(Xcell) % mean the 3D matrix across the third dimension
    Xmatrix = MakeMatrix(Xcell);
    matrixMean = mean(Xmatrix,3);
end
%-------------------------------------------------------------------------------
function Xmatrix = MakeMatrix(Xcell) % turn cell entries into a slice in a 3D matrix
    [x,y] = size(Xcell{1});
    Xmatrix = zeros(x,y,length(Xcell));
    for k = 1:length(Xcell)
        Xmatrix(:,:,k) = Xcell{k};
    end
end
%-------------------------------------------------------------------------------

end
