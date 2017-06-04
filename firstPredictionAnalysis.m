load('matrixData.mat','h','v','k','geneEntrez');

% Filter out genes with missing data:
isMissing = sum(isnan(v)) > 0;
v = v(:,~isMissing);
geneEntrez = geneEntrez(:,~isMissing);
fprintf(1,'Filtered %u missing genes\n',sum(isMissing));

% Normalize expression:
vNorm = BF_NormalizeMatrix(v,'zscore');

%% Analysis with hub/nonhub
% Order by hub/nonhub
[~,ix] = sort(h,'descend');

% Plot normalized, sorted:
f = figure('color','w');
imagesc(vNorm(ix,:))


%% Compute differences:
numGenes = size(v,2);
tStats = zeros(numGenes,1);
for i = 1:numGenes
    [~,~,~,stats] = ttest2(v(h==0,i),v(h==1,i));
    tStats(i) = stats.tstat;
end
% Sort by differences:
[~,iy] = sort(tStats,'descend');

% Print the gene entrez of genes with differential expression between hubs vs nonhubs, from highest to lowest
fprintf('Genes with differential expression between hubs vs nonhubs in descending order of difference: \n')
diffExpSeq=geneEntrez(iy)

%% Plot normalized, sorted:
f = figure('color','w');
imagesc(vNorm(ix,iy))

%-------------------------------------------------------------------------------
%% Machine learning prediction of hub/nonhub:
%-------------------------------------------------------------------------------
hLabels = h+1; % hubs are '2', nonhubs are '1'
numRepeats = 200;
accuracies = zeros(numRepeats,1);
for i = 1:numRepeats
    [accuracy,Mdl,whatLoss] = GiveMeCfn('svm_linear',vNorm,hLabels,vNorm,hLabels,...
                                2,true,'balancedAcc',true,5);
    accuracies(i) = mean(accuracy);
end
fprintf(1,'Balanced classification accuracy = %.1f +/- %.1f%%\n',mean(accuracies),std(accuracies));
%-------------------------------------------------------------------------------

%% Analysis with degree

% Order by degree
[~,ixk] = sort(k,'descend')

% Plot normalized, sorted by degree:
f = figure('color','w');
imagesc(vNorm(ixk,:))
%%
% Define high-degree nodes (i.e. nodes with a degree at least one
% standard deviation above the network mean)
z=zscore(k);
highDegNode=z>=1

%% Compute differences between high and low degree nodes:
numGenes = size(v,2);
tStats = zeros(numGenes,1);
for i = 1:numGenes
    [~,~,~,stats] = ttest2(v(z==0,i),v(z==1,i));
    tStats(i) = stats.tstat;
end

% Sort by differences:
[~,iyk] = sort(tStats,'descend');

% Print the gene entrez of genes with differential expression between high degree vs low degree nodes, from highest to lowest
fprintf('Genes with differential expression between high degree vs low degree nodes in descending order of difference: \n')
diffExpSeq=geneEntrez(iyk)

%% Plot normalized, sorted by degree and t-statistic:
f = figure('color','w');
imagesc(vNorm(ixk,iyk))

%% Machine learning prediction of high vs low degree nodes:
%-------------------------------------------------------------------------------
zLabel = highDegNode+1; % high degree nodes are '2', low degree nodes are '1'
numRepeats = 200;
accuracies = zeros(numRepeats,1);
for i = 1:numRepeats
    [accuracy,Mdl,whatLoss] = GiveMeCfn('svm_linear',vNorm,zLabel,vNorm,zLabel,...
                                2,true,'balancedAcc',true,3);
    accuracies(i) = mean(accuracy);
end
fprintf(1,'Balanced classification accuracy = %.1f +/- %.1f%%\n',mean(accuracies),std(accuracies));
