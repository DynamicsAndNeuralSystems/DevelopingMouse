load('newmatrixData.mat','h','V','k','geneEntrez');

%% Set conditions to be used later
% Order by hub/nonhub
[~,ix] = sort(h,'descend');
% Create empty cell array to store gene info strings 
diffExpSeqHub=cell(7,1);
diffExpSeqDeg=cell(7,1);
geneEntrezleft=cell(7,1); 
% Order by degree
[~,ixk] = sort(k,'descend')
% Define high-degree nodes (i.e. nodes with a degree at least one standard deviation above the network mean)
z=zscore(k);
% Create a vector of indices of high-degree nodes
highDegNode=z>=1;

%% Loop the analysis through all developmental stages
for i=1:7
    % Filter out genes with missing data:
    isMissing = sum(isnan(V{i})) > 0;
    V{i} = V{i}(:,~isMissing);
    geneEntrezleft{i} = geneEntrez(:,~isMissing);
    fprintf(1,'Filtered %u missing genes\n',sum(isMissing));
    
    %discard the set of data if more than 90% of gene is missing
    if sum(isMissing)>(0.9*80)
        continue
    end

    % Normalize expression:
    vNorm{i} = BF_NormalizeMatrix(V{i},'zscore');
    % Hub/nonhub analysis
    % Plot normalized, sorted in the order of hub to nonhub:
    f = figure('color','w');
    imagesc(vNorm{i}(ix,:))
    title('Normalized gene expression sorted by hub status in rows')
    
    % Compute differences:
    numGenes = size(V{i},2);
    tStats = zeros(numGenes,1);
    for j = 1:numGenes
        [~,~,~,stats] = ttest2(V{i}(h==0,j),V{i}(h==1,j));
        tStats(j) = stats.tstat;
    end
    % Sort by differences:
    [~,iy] = sort(tStats,'descend');
    
    % Print the gene entrez of genes with differential expression between hubs vs nonhubs, from highest to lowest
    %diffExpSeqHub{i}=geneEntrezleft{i}(iy);
    %fprintf('Genes with differential expression between hubs vs nonhubs in descending order of difference: \n')
    %diffExpSeqHub{i}

    % Plot normalized, sorted:
    f = figure('color','w');
    imagesc(vNorm{i}(ix,iy))
    title('Normalized gene expression sorted by hub status in rows and differential expression in columns')
    
    % Analysis with degree
    % Plot normalized, sorted by degree:
    f = figure('color','w');
    imagesc(vNorm{i}(ixk,:))
    title('Normalized gene expression sorted by degree in rows')

    % Compute differences between high and low degree nodes:
    numGenes = size(V{i},2);
    tStats = zeros(numGenes,1);
        for k = 1:numGenes
            [~,~,~,stats] = ttest2(V{i}(z==0,i),V{i}(z==1,i));
            tStats(k) = stats.tstat;
        end

        % Sort by differences:
        [~,iyk] = sort(tStats,'descend');

        % Print the gene entrez of genes with differential expression between high degree vs low degree nodes, from highest to lowest
        %diffExpSeqDeg{i}=geneEntrezleft{i}(iyk);
        %fprintf('Genes with differential expression between high degree vs low degree nodes in descending order of difference: \n')
        %diffExpSeqDeg{i}

    % Plot normalized, sorted by degree and t-statistic:
    f = figure('color','w');
    imagesc(vNorm{i}(ixk,iyk))
    title('Normalized gene expression sorted by degree in rows and differential expression in columns')


    %-------------------------------------------------------------------------------
    %% Machine learning prediction of hub/nonhub:
    %-------------------------------------------------------------------------------
    hLabels = h+1; % hubs are '2', nonhubs are '1'
    numRepeats = 200;
    accuracies = zeros(numRepeats,1);
        for m = 1:numRepeats
            [accuracy,Mdl,whatLoss] = GiveMeCfn('svm_linear',vNorm{i},hLabels,vNorm{i},hLabels,...
                                2,true,'balancedAcc',true,5);
            accuracies(m) = mean(accuracy);
        end
    fprintf(1,'Balanced classification accuracy = %.1f +/- %.1f%%\n',mean(accuracies),std(accuracies));
    %-------------------------------------------------------------------------------
    %% Machine learning prediction of high vs low degree nodes:
    %-------------------------------------------------------------------------------
    zLabel = highDegNode+1; % high degree nodes are '2', low degree nodes are '1'
    numRepeats = 200;
    accuracies = zeros(numRepeats,1);
        for n = 1:numRepeats
            [accuracy,Mdl,whatLoss] = GiveMeCfn('svm_linear',vNorm{i},zLabel,vNorm{i},zLabel,...
                                2,true,'balancedAcc',true,3);
            accuracies(n) = mean(accuracy);
        end
    fprintf(1,'Balanced classification accuracy = %.1f +/- %.1f%%\n',mean(accuracies),std(accuracies));
end
