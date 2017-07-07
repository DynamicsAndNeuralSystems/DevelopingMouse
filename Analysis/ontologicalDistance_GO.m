%%
% User input; must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
whatNorm='log2';
% User input: which field from DevMouseGeneExpression you want to use: 'norm' or normStructure';
% 'norm' is normalized across genes using a method specified in file name,
% or otherwise ScaledSigmoid; if normStructure is chosen, it doesn't matter
% what "whatNorm" is as long as the DevMouseGeneExpression.mat is up to
% date (i.e. contains the field "normStructure") [at the moment, only whatNorm='log2' is up to date]
whichField={'normStructure'};
% User input: Choose whether to plot the graph, which takes much longer running time) (plot=1;no plot=0)
plotGraph=0;

if whatNorm==' '
    genefile=sprintf('DevMouseGeneExpression.mat');
else
    genefile=sprintf('DevMouseGeneExpression%s.mat',strcat('_',whatNorm));
end

load(genefile)
load('dataDevMouse.mat')
load('maxDistance.mat')
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
fitMethods={'linear','exp_1_0','exp1','exp',};

%% experimentation (half done)
[GOTable,geneEntrezAnnotations] = GetFilteredGOData('biological_process',[5,200],geneEntrez);
% import GO ID related to CNS
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables\Others'
goCatID=xlsread('GO_CNS_related.xlsx',1,'B2:B235');
isRelated=ismember(GOTable.GOID,goCatID);
%%
geneEntrezAnnotationsRelated=geneEntrezAnnotations(isRelated);
geneEntrezRelated=cell(length(geneEntrezAnnotationsRelated),1); % for each GO group, there are a number of genes
for i=1:length(geneEntrezAnnotationsRelated)
    geneEntrezRelated{i}=geneEntrez(ismember(geneEntrez,geneEntrezAnnotationsRelated{i}));
end
%% Use only genes in a particular category to calculate the results
isGO=cell(length(geneEntrezRelated),1);
for j=1
    isGO{j}=(geneEntrez==geneEntrezRelated{j});
end



