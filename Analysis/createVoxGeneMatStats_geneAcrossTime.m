timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('geneID_gridExpression.mat')
% collect the set of genes that are present in any time points
SDKgeneEntrez = importfile_SDK_geneEntrez('SDK_geneEntrez.csv');
% [~,geneAbbreviation,~]=xlsread('SDK_geneAbbreviations.csv','A1:CBX1');
% initialize
isGoodGene_all=cell(length(timePoints),1);
geneIDInfo_all=cell(length(timePoints),1);
isGoodGene_all_index=cell(length(timePoints),1);
geneMatrix=zeros(length(timePoints),length(SDKgeneEntrez));
% collect data on which genes are good in each time point
for i=1:length(timePoints)
  % collect good gene index
  load(strcat('voxelGeneCoexpression_',timePoints{i},'.mat'));
  isGoodGene_all{i}=isGoodGene;
  % find out the good genes in each time point as an index of SDKgeneEntrez
  isGoodGene_all_index{i}=ismember(...
                                cellfun(@(x) num2str(x), SDKgeneEntrez,'UniformOutput',false),...
                                cellfun(@(x) num2str(x), ...
                                    geneID_gridExpression.(timePoints{i})(isGoodGene_all{i}),...
                                    'UniformOutput',false));
  % create a matrix of on-off genes
  geneMatrix(i,:)=isGoodGene_all_index{i};
end

f=figure('color','w','Position',get(0,'Screensize'));
imagesc(geneMatrix)
colormap([0 0 0; 1 1 1])
xlabel('Genes')
ylabel('Time Points')
ax = gca;
ax.YTickLabel=timePoints;
% set(gca,'xtick',[1:length(SDKgeneEntrez)],'xticklabel',geneAbbreviation)
title('Gene status across time points', 'FontSize', 14)
F=getframe(f);
str=fullfile('Outs','voxGeneMatStats_geneAcrossTime','voxGeneMatStats_geneAcrossTime.jpeg');
imwrite(F.cdata,str,'jpeg')

% get subset of genes that are good across time points
goodGeneSubset=SDKgeneEntrez(arrayfun(@(x) x==7, sum(geneMatrix)));
str=fullfile('Matlab_variables','goodGeneSubset.mat');
save(str,'goodGeneSubset','isGoodGene_all','isGoodGene_all_index');
