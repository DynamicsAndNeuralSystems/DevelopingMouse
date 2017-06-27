load('DevMouseGeneExpression_Rubinov.mat');
%%
h=[zeros(1,23),1,1,1,1,1,1,0,0];
geneEntrezLeft=cell(7,1); 
geneNameLeft=cell(7,1); 
structuresNeedLeft=cell(7,1); 
%% Set conditions to be used later
% % Order by hub/nonhub
% [~,ix] = sort(h,'descend');
% Create empty cell array to store gene info strings 
diffExpSeqHub=cell(7,1);
% diffExpSeqDeg=cell(7,1);

% Create empty cell to store GOtables
GOTableCell=cell(7,1);
% Create empty cell to store Gene Entrez Annotations of the GO tables
geneEntrezAnnotationsCell=cell(7,1);
% Create empty cell to store accuracies (mean,1 SD) of SVM prediction 
accuraciesSvmCell=cell(7,1);
% Create empty cells/matrices to store the p values
pValHub=cell(7,1);
pValHub2=cell(7,1);
pValHub3=cell(7,1);
pValCorr=zeros(7,1);
% Create empty cell to store structure x gene matrices of genes enriched in
% hubs
sigPValHub2=cell(7,1);
sigPValHub3=cell(7,1);
% % Order by degree
% [~,ixk] = sort(k,'descend')
% % Define high-degree nodes (i.e. nodes with a degree at least one standard deviation above the network mean)
% z=zscore(k);
% % Create a vector of indices of high-degree nodes
% highDegNode=z>=1;

%% Loop the analysis through all developmental stages
%expMeasure = {'Energy','Density'};
% turn norm dataset into a 3D matrix 
matExpEnergy=MakeMatrix(Exp.Energy.rawAverage);
%%
% permute dimensions
matExpEnergy=permute(matExpEnergy,[3,2,1]);
V=cell(7,1);
vNorm=cell(7,1);
hLeft=cell(7,1);
%%
for i=1:7
    V{i}=squeeze(matExpEnergy(:,:,i));
    % filter out structures without any gene data
    structMissing=all(isnan(V{i}),2);
    V{i}=V{i}(~structMissing,:);
    structuresNeedLeft{i}=structuresNeed(:,~structMissing);
    hLeft{i}=h(~structMissing);
    fprintf(1,'Filtered %u missing structures\n',sum(structMissing));
    % Filter out genes with missing data:
    isMissing = sum(isnan(V{i})) > 0;
    V{i}=V{i}(:,~isMissing);
    geneEntrezLeft{i} = geneEntrez(:,~isMissing);
    geneNameLeft{i} = geneList(:,~isMissing);
    fprintf(1,'Filtered %u missing genes\n',sum(isMissing));
    %discard the set of data if more than 90% of gene is missing
    if sum(isMissing)>(0.9*length(geneEntrez))
        continue
    end

    % Normalize expression:
    vNorm{i}= BF_NormalizeMatrix(V{i},'zscore');
    %-------------------------------------------------------------------------------
    % Machine learning prediction of hub/nonhub:
    %-------------------------------------------------------------------------------

    hLabels = hLeft{i}+1; % hubs are '2', nonhubs are '1'
    numRepeats = 200;
    accuracies = zeros(numRepeats,1);
    % check number of hubs here
    numHubs=sum(hLeft{i});
    if numHubs==0
        continue
    end
    for m = 1:numRepeats
        [accuracy,Mdl,whatLoss] = GiveMeCfn('svm_linear',vNorm{i},hLabels,vNorm{i},hLabels,...
                                2,true,'balancedAcc',true,numHubs);
            accuracies(m) = mean(accuracy);
    end
    
    fprintf(1,'Balanced classification accuracy = %.1f +/- %.1f%%\n',mean(accuracies),std(accuracies));
    accuraciesSvmCell{i}=[mean(accuracies),std(accuracies)];
    
end

    
%% Plot SVM accuracies over 7 time points with error bars
xPlot=[1:7];
%create vector containing mean accuracies
yAccuracyPlot=zeros(1,7);
for i=1:7
    yAccuracyPlot(i)=accuraciesSvmCell{i}(1);
end
%create vector containing errors
yErrorPlot=zeros(1,7);
for i=1:7
    yErrorPlot(i)=accuraciesSvmCell{i}(2);
end
% Plot the error bar graph over time
f = figure('color','w');
errorbar(xPlot,yAccuracyPlot,yErrorPlot)
ylim([0 100])
xlabel('Developmental time points','FontSize', 16)
ax = gca;
ax.XTick=[1 2 3 4 5 6 7];
ax.XTickLabel={'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'};
set(gca,'fontsize',16)
ylabel('Prediction accuracy (%)','FontSize', 16)
title('Accuracy of predicting hub status from genes with SVM over time','FontSize', 19)
%% Compute differences with one-tailed two sample t test (test alternative hypothesis that each gene is more expressed in hubs than nonhubs)
tStats2=cell(7,1);
for i=1:7
    numHubs=sum(hLeft{i});% check number of hubs here
    if numHubs==0
        continue
    end
    numGenes=length(geneEntrezLeft{i});
    tStats2{i} = zeros(numGenes,1);
    pValHub2{i} = zeros(numGenes,1);
    for j = 1:numGenes
        [~,p,~,stats] = ttest2(vNorm{i}(hLeft{i}==0,j),vNorm{i}(hLeft{i}==1,j),'Tail','left','Vartype','unequal'); 
        tStats2{i}(j) = stats.tstat;
        pValHub2{i}(j)=p;
    end

    % Order by hub/nonhub
    [~,ix] = sort(hLeft{i},'descend');
    % Sort by differences:
    [~,iy2] = sort(tStats2{i},'descend');
     % Plot normalized, sorted by t statistic:
     %f = figure('color','w');
     %imagesc(V{i}(ix,iy2))
     %colorbar
     %title('Developing Mouse %s, sorted t statistic, 1 tailed t, hypo more in hub',timePoints{i})

    % Sort by differences in p value:
    [~,iyp2] = sort(pValHub2{i},'ascend');
    % Plot normalized, sorted by p value:
    f = figure('color','w');
    imagesc(vNorm{i}(ix,iyp2))
    colorbar
    xlabel('Gene','FontSize', 16)
    %xticklabels({'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'})
    ax = gca;
    ax.XTick=[1:length(geneEntrezLeft{i})];
    ax.XTickLabel=geneNameLeft{i};
    ax.YTick=[1:length(structuresNeedLeft{i})];
    ax.YTickLabel=structuresNeedLeft{i};
    currentTimePoint=timePoints{i};
    str = sprintf('Developing Mouse %s Gene Expression, sorted p value, 1 tailed t, hypo more in hub',currentTimePoint);
    title(str)
    figFileName=sprintf('DevMouse_%s_Gene_Expression.jpg',currentTimePoint);
    saveas(gcf,figFileName)
    
    % gene enrichment analysis
    [GOTable,geneEntrezAnnotations] = SingleEnrichment(tStats2{i},geneEntrezLeft{i}); 
    GOTableCell{i}=GOTable;
    geneEntrezAnnotationsCell{i}=geneEntrezAnnotations;
end
    %%
save('SVMresults.mat','accuraciesSvmCell')
save('GOresults.mat','GOTableCell')
%%    
    
    % Normalize expression:
    %vNorm{i} = BF_NormalizeMatrix(V{i},'zscore');
    
%     % Plot normalized, sorted in the order of hub to nonhub:
%     
%     f = figure('color','w');
%     imagesc(vNorm{i}(ix,:))
%     title('Normalized gene expression sorted by hub status in rows')
%     
%     % Compute differences with two-tailed two sample t test:
%     numGenes = size(V{i},2);
%     tStats = zeros(numGenes,1);
%     % pValHub = zeros(numGenes,1); %Create zero vector to store p values
%     for j = 1:numGenes
%         [~,p,~,stats] = ttest2(V{i}(h==0,j),V{i}(h==1,j),'Vartype','unequal'); % high t statistic = differentially enriched in non-hubs ?!
%         tStats(j) = stats.tstat;
%         pValHub{i}(j)=p;
%     end
%     % Sort by differences in t statistic:
%     [~,iy] = sort(tStats,'descend');
%     % Plot normalized, sorted:
%     f = figure('color','w');
%     imagesc(vNorm{i}(ix,iy))
%     title('sorted t statistic, 2 tailed t, hypo different')
%     
%     % Sort by differences in p value:
%     [~,iyp] = sort(pValHub{i},'ascend');
%     % Plot normalized, sorted:
%     f = figure('color','w');
%     imagesc(vNorm{i}(ix,iyp))
%     title('sorted p value, 2 tailed t, hypo different')
    
    
    %%
    % Compute differences with one-tailed two sample t test (test alternative hypothesis that each gene is more expressed in nonhubs than hubs)
    tStats3 = zeros(numGenes,1);
    for j = 1:numGenes
        [~,p,~,stats] = ttest2(V{i}(h==0,j),V{i}(h==1,j),'Tail','right','Vartype','unequal'); % high t statistic = differentially enriched in non-hubs ?!
        tStats3(j) = stats.tstat;
        pValHub3{i}(j)=p;
    end
    % Sort by differences:
    [~,iy3] = sort(tStats3,'descend');
    
    % Plot normalized, sorted by t statistic:
    f = figure('color','w');
    imagesc(vNorm{i}(ix,iy3))
    title('sorted t statistic, 1 tailed t, hypo more in nonhub')
    
    % Sort by differences in p value:
    [~,iyp3] = sort(pValHub3{i},'ascend');
    
    % Plot normalized, sorted by p value:
    f = figure('color','w');
    imagesc(vNorm{i}(ix,iyp3))
    title('sorted p value, 1 tailed t, hypo more in nonhub')
    
%% Difference in correlation between hubs and nonhub enriched genes 
    %find the genes that are significantly enriched in hubs and nonhubs
    indexPValHub2=find(pValHub2{i}<0.05);
    indexPValHub3=find(pValHub3{i}<0.05);
    sigPValHub2{i}=vNorm{i}(:,indexPValHub2);
    sigPValHub3{i}=vNorm{i}(:,indexPValHub3);
    % Compute correlation coefficient matrix between genes enriched in hubs and nonhubs
    corrSigPValHub2=corrcoef(sigPValHub2{i});
    corrSigPValHub3=corrcoef(sigPValHub3{i});
    % Extract upper triangular elements of the correlation coefficient matrix and put into a vector    
    vecCorrSigPValHub2=corrSigPValHub2(find(~tril(ones(size(corrSigPValHub2)))));
    vecCorrSigPValHub3=corrSigPValHub3(find(~tril(ones(size(corrSigPValHub3)))));
    % 2 sample t test to compare the two groups
    [~,p,ci,stats] = ttest2(vecCorrSigPValHub2,vecCorrSigPValHub3,'Vartype','unequal')
    pValCorr(i)=p;
    if p<0.05
        fprintf('In time point %d, there is a significant difference between the correlation among genes enriched in hubs and those in nonhubs\n', i)
    else 
        fprintf('In time point %d, there is no difference between the correlation among genes enriched in hubs and those in nonhubs\n', i)
    end

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
    accuraciesSvmCell{i}=[mean(accuracies),std(accuracies)];

%% Plot SVM accuracies over 7 time points with error bars
xPlot=[1:7];
%create vector containing mean accuracies
yAccuracyPlot=zeros(1,7);
for i=1:7
    yAccuracyPlot(i)=accuraciesSvmCell{i}(1);
end
%create vector containing errors
yErrorPlot=zeros(1,7);
for i=1:7
    yErrorPlot(i)=accuraciesSvmCell{i}(2);
end
% Plot the error bar graph over time
errorbar(xPlot,yAccuracyPlot,yErrorPlot)
title('Accuracy of predicting hub status from genes with SVM over time')

%%

cd 'D:\Data\DevelopingAllenMouseAPI-master\Rubinov regions_80 genes'
save('GOresults.mat','GOTableCell','geneEntrezAnnotationsCell') % GO results
save('SVMaccuracies.mat','accuraciesSvmCell') % SVM results
save('HubData.mat','pValHub','pValHub2','pValHub3','pValCorr','sigPValHub2','sigPValHub3') % save t test results

%%
    % Print the gene entrez of genes with differential expression between hubs vs nonhubs, from highest to lowest
    %diffExpSeqHub{i}=geneEntrezleft{i}(iy);
    %fprintf('Genes with differential expression between hubs vs nonhubs in descending order of difference: \n')
    %diffExpSeqHub{i}

    
%     
%     hierarchical clustering [sth wrong, need to fix]
%     temp=vNorm{i}(ix,iy);
%     Y=pdist(temp); 
%     Z=linkage(Y);
%     [H,T,~]=dendrogram(Z)
%     orderHierarchical=[29,30,26,1,12,22,8,11,3,4,5,9,13,24,23,18,15,6,25,27,19,20,21,2,10,16,14,28,7,17];
%     Calculate correlation between genes sorted by hierarchical clustering between columns)
%     normCorrGenes=cell(1,7);
%     corrGenes=corrcoef(vNorm{i}(ix,iy)) %sth wrong with this, fix tmr
%     normCorrGenes{i}=BF_NormalizeMatrix(corrGenes,'zscore');
%     f=figure('color','w')
%     imagesc(normCorrGenes{i})
%     colorbar    

% %%
%     % Analysis with degree
%     % Plot normalized, sorted by degree:
%     f = figure('color','w');
%     imagesc(vNorm{i}(ixk,:))
%     title('Normalized gene expression sorted by degree in rows')
% 
%     % Compute differences between high and low degree nodes:
%     numGenes = size(V{i},2);
%     tStats = zeros(numGenes,1);
%         for k = 1:numGenes
%             [~,~,~,stats] = ttest2(V{i}(highDegNode==0,k),V{i}(highDegNode==1,k));
%             tStats(k) = stats.tstat;
%         end
%         
%         % Sort by differences:
%         [~,iyk] = sort(tStats,'descend');
% 
%         % Print the gene entrez of genes with differential expression between high degree vs low degree nodes, from highest to lowest
%         %diffExpSeqDeg{i}=geneEntrezleft{i}(iyk);
%         %fprintf('Genes with differential expression between high degree vs low degree nodes in descending order of difference: \n')
%         %diffExpSeqDeg{i}
% 
%     % Plot normalized, sorted by degree and t-statistic:
%     f = figure('color','w');
%     imagesc(vNorm{i}(ixk,iyk))
%     title('Normalized gene expression sorted by degree in rows and differential expression in columns')
% 
% 
%     
%     %-------------------------------------------------------------------------------
%     %% Machine learning prediction of high vs low degree nodes:
%     %-------------------------------------------------------------------------------
%     zLabel = highDegNode+1; % high degree nodes are '2', low degree nodes are '1'
%     numRepeats = 200;
%     accuracies = zeros(numRepeats,1);
%         for n = 1:numRepeats
%             [accuracy,Mdl,whatLoss] = GiveMeCfn('svm_linear',vNorm{i},zLabel,vNorm{i},zLabel,...
%                                 2,true,'balancedAcc',true,3);
%             accuracies(n) = mean(accuracy);
%         end
%     fprintf(1,'Balanced classification accuracy = %.1f +/- %.1f%%\n',mean(accuracies),std(accuracies));
%% troubleshooting
i=7;
% Filter out genes with missing data:
V=squeeze(matExpEnergy(:,:,i));
% isMissing = sum(isnan(V)) > 0;
% V=V(:,~isMissing);
% geneEntrezleft{i} = geneEntrez(:,~isMissing);
% fprintf(1,'Filtered %u missing genes\n',sum(isMissing));
% %discard the set of data if more than 90% of gene is missing
% if sum(isMissing)>(0.9*80)
%     continue
% end
%     % Normalize expression:
%vNorm= BF_NormalizeMatrix(V,'zscore');
%%
    %-------------------------------------------------------------------------------
    % Machine learning prediction of hub/nonhub:
    %-------------------------------------------------------------------------------
hLabels = h+1; % hubs are '2', nonhubs are '1'
% filter structures without any gene expression data available
hLabels=(hLabels(~all(isnan(V),2)))';
V=V(~all(isnan(V),2),:);
%%
numRepeats = 200;
accuracies = zeros(numRepeats,1);
for m = 1:numRepeats
    [accuracy,Mdl,whatLoss] = GiveMeCfn('svm_linear',V,hLabels,V,hLabels,...
                                2,true,'balancedAcc',true,2);
     accuracies(m) = mean(accuracy);
end
    
    fprintf(1,'Balanced classification accuracy = %.1f +/- %.1f%%\n',mean(accuracies),std(accuracies));
   % accuraciesSvmCell{i}=[mean(accuracies),std(accuracies)];