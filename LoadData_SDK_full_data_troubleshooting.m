cd 'D:\Data\DevelopingAllenMouseAPI-master\Rubinov regions_all genes\Data'
%-------------------------------------------------------------------------------
% Specify structures:
%-------------------------------------------------------------------------------
% Future 'AON'= 'AOV'+'AOD' and  Future 'COA'='PMCo', 'PLCo', 'ACo' 
structures={'CA','DG','POTel','THy','SeSPall', 'PaSe','PHy','AOB','AOV','AOD','OB','TTe','PMCo','PLCo', 'ACo','Dg_lower'...
    'Pal','ASPall','Stri','is','CbV','r1','CbH','r2','PH','PMH','MH','RSCx','Strp','p2','p3','p1','m1','CCx','AON','COA'};
ownStructure = [ones(1,34),0,0]; % specifies if each structure is it's own entity (AON and COA consists of several structures)
toBeCombined={'AOV','AOD','PMCo','PLCo','ACo'};
%groupedStructures=[zeros(1,34),1,1];
ixStructuresNeed=[1:8,11:12,16:36];
structuresNeed=structures(ixStructuresNeed);
% (needs to have all ones first)
numStructures = length(structures);
numToBeCombined=length(toBeCombined);
numStructureNeed=numStructures-numToBeCombined;
%%
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
            Exp.(expMeasure{i}).raw{j} = importfile2(fileName);
        else
            switch structures{j}
            case 'AON' % Future 'AON'= 'AOV'+'AOD' and  Future 'COA'='PMCo', 'PLCo', 'ACo' 
                % Add 'AON' as the mean across AOV (9), AOD (10)
                Exp.(expMeasure{i}).raw{j} = MeanCellMatrices(Exp.(expMeasure{i}).raw(9:10));
            case 'COA'
                % Add 'COA' as the mean across PMCo (13), PLCo (14), ACo (15)
                Exp.(expMeasure{i}).raw{j} = MeanCellMatrices(Exp.(expMeasure{i}).raw(13:15));
            end
        end
    end
end
%%
geneEntrez = xlsread('SDK_geneEntrez.csv');
[~,geneList,~]  = xlsread('SDK_geneAbbreviations.csv');
[~,timePoints,~] = xlsread('SDK_timePoints.csv');

numGenes = length(geneList);

%%
%-------------------------------------------------------------------------------
% Filter on expression energy
%-------------------------------------------------------------------------------
% We want to keep genes that have good values in the structures over time
hasData = zeros(numGenes,numStructures); % not for grouped data in vermis
%%
switch filterHow
case 'any' % you want at least one data point
    for i = 1:numStructures
        if ownStructure(i)
            hasData(:,i) = ~all(isnan(Exp.Energy.raw{i})); % a structure is dubbed 'hasData=1' if at least 1 gene has data
        end
    end
case 'multiple' % you want at least three data points
    %%
    for i = 1:numStructures
            hasData(:,i) = sum(~isnan(Exp.Energy.raw{i})) > 2; % a structure is dubbed 'hasData=1' if
    end
end
%%
% At least one of the key structures meets the inclusion criterion:
hasData = (sum(hasData,2) > 0);

% Now filter gene list based on these criteria (for all structures)
fprintf(1, 'Filtering gene list from %u down to %u using ''%s''\n',numGenes,sum(hasData),'multiple');
geneList = geneList(hasData);
geneEntrez = geneEntrez(hasData);
numGenes = length(geneList);
%%
for i = 1:length(expMeasure)
    fieldName = expMeasure{i};
    for j = 1:numStructures
        Exp.(fieldName).raw{j} = Exp.(fieldName).raw{j}(:,hasData);
    end
end
%%
%-------------------------------------------------------------------------------
% Normalize expression data
%-------------------------------------------------------------------------------

%----Save as norm field for each structure and gene separately
for g = 1:length(expMeasure)
    Exp.(expMeasure{g}).norm = cell(numStructureNeed,1);
    for i = 1:numStructureNeed
        Exp.(expMeasure{g}).norm{i} = BF_NormalizeMatrix(Exp.(expMeasure{g}).raw{ixStructuresNeed(i)},'scaledSigmoid');
    end

    % % Add the vermis as the mean across r1R,isA,isR
    % if vermisNormAsMean
    %     Exp.(expMeasure{g}).norm{numStructures+1} = MeanCellMatrices(Exp.(expMeasure{g}).norm(2:4));
    % else
    %     % Treat it like any other structure
    %     Exp.(expMeasure{g}).norm{numStructures+1} = BF_NormalizeMatrix(Exp.(expMeasure{g}).raw{i},whatNorm);
    % end
end
%%
%----Save as normGene field for each gene separately (relative to all structures and time points)
% 7 or 8 (with P56) [time] x 2104 [gene] x 5 [structure]
% allRawData = MakeMatrix(Exp.(expMeasure{g}).raw);


allRawData = vertcat(Exp.Energy.raw{ixStructuresNeed}); % each gene across all time and structures (skipping AOV (9), AOD (10), PMCo (13), PLCo (14), ACo (15)) 
meanTime = nanmean(allRawData,1);
stdTime = nanstd(allRawData,1);
sigmoidNorm = @(x,ind) 1./(1 + exp(-(x-meanTime(ind))/stdTime(ind)));


for g = 1:length(expMeasure)
    Exp.(expMeasure{g}).normGene = cell(numStructureNeed,1); 
    for i = 1:numStructureNeed % for each structure needed
        Exp.(expMeasure{g}).normGene{i} = zeros(size(Exp.(expMeasure{g}).raw{ixStructuresNeed(i)}));
        for j = 1:numGenes
            Exp.(expMeasure{g}).normGene{i}(:,j) = sigmoidNorm(Exp.(expMeasure{g}).raw{ixStructuresNeed(i)}(:,j),j);
        end
    end
end
