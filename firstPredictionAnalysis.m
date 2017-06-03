load('matrixData.mat','h','v','k');
% Filter out genes with missing data:
isMissing = sum(isnan(v)) > 0;
v = v(:,~isMissing);
fprintf(1,'Filtered %u missing genes\n',sum(isMissing));

% Normalize expression:
vNorm = BF_NormalizeMatrix(v,'zscore');

% Order by hub/nonhub
[~,ix] = sort(h,'descend');

% Plot normalized, sorted:
f = figure('color','w');
imagesc(vNorm(ix,:))

% Order by degree
[~,ixk] = sort(k,'descend')

% Plot normalized, sorted by degree:
f = figure('color','w');
imagesc(vNorm(ixk,:))

%% Compute differences:
numGenes = size(v,2);
tStats = zeros(numGenes,1);
for i = 1:numGenes
    [~,~,~,stats] = ttest2(v(h==0,i),v(h==1,i));
    tStats(i) = stats.tstat;
end
% Sort by differences:
[~,iy] = sort(tStats,'descend');

%% Plot normalized, sorted:
f = figure('color','w');
imagesc(vNorm(ix,iy))

%% Plot normalized, sorted by degree:
f = figure('color','w');
imagesc(vNorm(ixk,iy))
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
