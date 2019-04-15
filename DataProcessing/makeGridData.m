% user input: number of data used in analysis
numData=1000;
% user input: current time point
timePointNow={'P28'};
% user input: matlab variable directory
varDir='D:\Data\DevelopingMousePhase2\readGridData';

% this script creates a voxel x gene matrix with irrelevant voxels filtered out
sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
i=find(cellfun(@(c)strcmp(timePointNow,c),timePoints)); %match index to the chosen timepoint
resolutionGrid=struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,...
    'P14',200,'P28',200);
%% load variables
str=strcat(varDir,'\','energyGrids_',timePoints{i},'.mat');
load(str)
load('annotationGrids.mat')
load('spinalCord_ID.mat')
%%
tic

% filters
isSpinalCord=ismember(annotationGrids{i},spinalCord_ID);
isAnno=annotationGrids{i}>0;
% create coordinates
[a,b,c]=ind2sub(sizeGrids.(timePoints{i}),find(isAnno & ~isSpinalCord));
coOrds=horzcat(a,b,c);

% make voxel x gene matrix

voxGeneMat=zeros(nnz(isAnno & ~isSpinalCord),length(energyGrids));

h = waitbar(0,'Computing voxel x gene expression matrix...');
steps=length(energyGrids);
for j=1:size(voxGeneMat,2) % for each gene
    energyGridsNow=energyGrids{j};
    energyGridsNow=energyGridsNow(isAnno & ~isSpinalCord);
    for k=1:size(voxGeneMat,1) % for each voxel
        if energyGridsNow(k)<0
           voxGeneMat(k,j)=NaN;
        else
            voxGeneMat(k,j)=energyGridsNow(k);
        end
    end
    waitbar(j/steps)
end
close(h)

clear energyGrids
%% only keep good voxels
isGoodVoxel=(sum(isnan(voxGeneMat),2) < 0.3*size(voxGeneMat,2));

voxGeneMat=voxGeneMat(isGoodVoxel,:);
coOrds=coOrds(isGoodVoxel,:);
% normalize
voxGeneMat=BF_NormalizeMatrix(voxGeneMat,'scaledSigmoid');

%%
if numData>size(voxGeneMat,1)
    error('number of data analyzed cannot be larger than number of available voxels')
end

[dataIndSelect,~]=datasample([1:size(voxGeneMat,1)],numData,'replace',false);
geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');


distMat=squareform(pdist(coOrds(dataIndSelect,:),'euclidean')*resolutionGrid.(timePoints{i}));

%%
% extract the correlation coefficients
corrCoeff=geneCorr(find(triu(ones(size(geneCorr)),1)));

distance=distMat(find(triu(ones(size(distMat)),1)));

%% plot coexpression against distance
f=figure('color','w');
gcf;
scatter(distance,corrCoeff,'.')
xlabel('Separation Distance (um)','FontSize',16)
ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
str = sprintf('Developing Mouse %s',timePoints{i});
title(str,'Fontsize',19);
f=figureFullScreen(f,true); 
%% fitting

adjRSquare=struct();
fitObject=struct();
fitMethods={'linear','exp_1_0','exp1','exp'};
fHandle=struct();
%%

for j=1:length(fitMethods)
    [f_handle,Stats,c] = GiveMeFit(distance,corrCoeff,fitMethods{j},true);
    fitObject.(fitMethods{j})=c;
    fHandle.(fitMethods{j})=f_handle;
    adjRSquare.(fitMethods{j})=Stats.adjrsquare;
    confInt.(fitMethods{j})=confint(c,0.95);
    coeffValue.(fitMethods{j})=coeffvalues(c);
end

%%
matAdjRSquare=zeros(length(timePointNow),length(fitMethods)); 
for k=1:length(timePointNow)
    for j=1:length(fitMethods)
        matAdjRSquare(k,j)=adjRSquare.(fitMethods{j})(k);
    end
end

%%
% User input; must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
whatNorm=' ';
% User input: which field from DevMouseGeneExpression you want to use: 'norm' or normStructure';
% 'norm' is normalized across genes using a method specified in file name,
% or otherwise ScaledSigmoid; if normStructure is chosen, it doesn't matter
% what "whatNorm" is as long as the DevMouseGeneExpression.mat is up to
% date (i.e. contains the field "normStructure") [at the moment, only whatNorm='log2' is up to date]
% User input: Choose whether to plot the graph, which takes much longer running time) (plot=1;no plot=0)
plotGraph=0;


g=figure('color','w');
xAxis=[1:length(timePointNow)];
%BarChart=bar(matAdjRSquare,'grouped');
BarChart=bar(vertcat(matAdjRSquare,nan(size(matAdjRSquare))));

BarChat.BarWidth = 0.4;
ax = gca;

ax.XTick=[1];
ax.XTickLabel=timePointNow;

xt=[1];

if whatNorm==' ';
    str=sprintf('Degree of freedom adjusted R-square, scaled sigmoid');
else
    str=sprintf('Degree of freedom adjusted R-square, %s',whatNorm);
end
Title=title(str);
set(Title, 'FontSize', 16)
grid on
grid minor

L = cell(1,4);
L{1}='linear';
L{2}='1 parameter exponential';
L{3}='2 parameter exponential';
L{4}='3 parameter exponential';
legend(BarChart,L,'Location','northeast')
hold on

g=figureFullScreen(g,true); 

%% plot exponential fit
w=figure('color','w');
gcf;
scatter(distance,corrCoeff,'.')
hold on
xData=linspace(min(distance),max(distance),0.1*length(distance));
p=plot(xData,fHandle.exp(xData),'-x'); 
set(p,'Color','k')
legend(p,'Exponential fit')
xlabel('Separation Distance (um)','FontSize',16)
ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
str = sprintf('Developing Mouse %s',timePoints{i});
title(str,'Fontsize',19);
w=figureFullScreen(w,true); 


%% save variables and figures
cd 'D:\Data\DevelopingMousePhase2\makeGridData1_var'
str=strcat('makeGridData1_',timePoints{i},'.mat');
save(str)
cd 'D:\Data\DevelopingMousePhase2\makeGridData1_fig'
str=strcat('GeneCoexpress_',timePoints{i},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
saveas(f,str)
str=strcat('R-square_exp_voxel_',timePoints{i},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
saveas(g,str)
str=strcat('expoFit_voxel_',timePoints{i},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
saveas(w,str)

%%
toc
