clear all
load('Rubinov connectome.csv')
load('newmatrixData.mat','cV')
%%
% extract the connectivity matrix of only one hemisphere (same side)
sameV=Rubinov_connectome([1:56],[1:56]);
% extract a submatrix consisting of only the regions in developing mouse
% (including those cortical regions with same name as adult), excluding
% "Dg'
index=[1,2,4:11,13,14,19:20,28:36,40,50:55];
devSameV=sameV(index,index);

%normalize matrix
normDevSameV=BF_NormalizeMatrix(devSameV,'zscore');
%create labels of hubs
hLabel=zeros(30,1);
hLabel(25:30)=1;
% plot the matrix sorted by hub to nonhub for visualization
% [~,ix]=sort(hLabel);
% f=figure('color','w')
% imagesc(normDevSameV(ix,ix))
% colorbar

%% check whether connectivity strength in adult is correlated with gene coexpression in developing mouse
%filter out genes with missing data
isMissing = sum(isnan(cV)) > 0;
cV = cV(:,~isMissing);
fprintf(1,'Filtered %u missing genes\n',sum(isMissing));
% compute overall gene coexpression between regions using correlation
coExpress=corrcoef(cV');
% binarize the connectivity matrix
%binDevSameV=threshold_proportional(devSameV, 0.3);
binDevSameV=weight_conversion(devSameV,'binarize');
% extract the upper triangular elements of the gene coexpression matrix and
% connectivity matrix
vCoExpress=coExpress(find(~tril(ones(size(coExpress)))));
vBinDevSameV=binDevSameV(find(~tril(ones(size(binDevSameV)))));
% perform one tailed t test to test the hypothesis that coexpression is
% higher when connection is present, without correcting for spatial relations
[~,p,~,stats] = ttest2(vCoExpress(vBinDevSameV==1),vCoExpress(vBinDevSameV==0),'Tail','right','Vartype','unequal')
% Correct for spatial relations by regression


% combine gene coexpression matrix with connectivity matrix to form a 3D
% % array
% geneConn=cat(3,normDevSameV,coExpress);
% plot points of (connectivity, gene coexpression)







