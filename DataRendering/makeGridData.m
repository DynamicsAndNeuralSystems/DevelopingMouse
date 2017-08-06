% user input the value of i (1=E11.5; 2=E13.5; 3=E15.5; 4=E18.5; 5=P4;
% 6=P14; 7=P28)
i=2;
% user input: number of data used in analysis
numData=1000;
% user input: current time point
timePointNow={'E13Pt5'};

% this script creates a voxel x gene matrix with irrelevant voxels filtered out
sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
resolutionGrid=struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,...
    'P14',200,'P28',200);

% user input: create a switch to filter off spinal cord voxels; 1=filter;
% 0=don't filter
filterSpinal=1;

%% load variables
load('energyGrids.mat')
load('timePointInfo.mat')
load('geneIDInfo.mat')
load('annotationGrids.mat')
% load('A.mat') % contains the directory where API data of all time points are stored

%%
tic
% make voxel x gene matrix
if filterSpinal==1
    load('spinalCordID.mat')
    % check energyGrids for spinal cord annotation
    isSpinalCord=ismember(annotationGrids{i},spinalCord_ID);
    indSpinalCord=find(isSpinalCord);
    voxGeneMat=zeros(length(energyGrids{i}{1})-nnz(isSpinalCord),length(energyGrids{i}));
    coOrds=zeros(length(energyGrids{i}{1})-nnz(isSpinalCord),3);
else
    voxGeneMat=zeros(length(energyGrids{i}{1}),length(energyGrids{i})); % initialize voxel x gene matrix
    coOrds=zeros(length(energyGrids{i}{1}),3);
end
h = waitbar(0,'Computing voxel x gene expression matrix and coordinates...');
steps=length(energyGrids{i});
for j=1:length(energyGrids{i}) % for each gene
    for k=1:size(voxGeneMat,1)% for each voxel
        if filterSpinal==1
            if ~isempty(indSpinalCord)
                if ~ismember(indSpinalCord,k)
                    voxGeneMat(k,j)=energyGrids{i}{j}(k);
                    annotationGridNow=annotationGrids{i};
                    x=find(annotationGridNow>0,k);
                    ind=x(end);
                    [xCoOrd,yCoOrd,zCoOrd]=ind2sub(sizeGrids.(timePoints{i}),ind);
                    coOrds(k,:)=[xCoOrd,yCoOrd,zCoOrd];
                end
            else
                voxGeneMat(k,j)=energyGrids{i}{j}(k);
                annotationGridNow=annotationGrids{i};
                x=find(annotationGridNow>0,k);
                ind=x(end);
                [xCoOrd,yCoOrd,zCoOrd]=ind2sub(sizeGrids.(timePoints{i}),ind);
                coOrds(k,:)=[xCoOrd,yCoOrd,zCoOrd];
            end
        end
        % record the expression data into the matrix
        if energyGrids{i}{j}(k)<0
            voxGeneMat(k,j)=NaN;
        else
            voxGeneMat(k,j)=energyGrids{i}{j}(k);
        end
    end
    waitbar(j/steps)
end
close(h)

clear energyGrids
%% only keep good voxels
isGoodVoxel=(sum(isnan(voxGeneMat),2) < 0.3*length(geneIDInfo{i}));
voxGeneMat=voxGeneMat(isGoodVoxel,:);
coOrds=coOrds(isGoodVoxel,:);
% normalize
voxGeneMat=BF_NormalizeMatrix(voxGeneMat,'scaledSigmoid');

% %% Compute coordinates
% 
% ind=find((annotationGrids{i}>0) & (~ismember(annotationGrids{i},spinalCord_ID))); % find index of annotated voxels and those that are not spinal cords
% [xCoOrd,yCoOrd,zCoOrd]=ind2sub(sizeGrids.(timePoints{i}),ind);
% coOrds=horzcat(xCoOrd,yCoOrd,zCoOrd);
% % only keep good voxels
% coOrds=coOrds(isGoodVoxel,:);
%%
%compute correlation coefficient matrix

% initialize
% corrCoeffMat=cell(length(A),1); 
% voxGeneMat_clean=cell(length(A),1);
% distMat=cell(length(A),1);
% coOrds_clean=cell(length(A),1);


if numData>size(voxGeneMat,1)
    error('number of data analyzed cannot be larger than number of available voxels')
end

[dataIndSelect,~]=datasample([1:size(voxGeneMat,1)],numData,'replace',false);
geneCorr=corrcoef((voxGeneMat(dataIndSelect,:))','rows','pairwise');
toc

distMat=squareform(pdist(coOrds(dataIndSelect,:),'euclidean')*resolutionGrid.(timePoints{i}));

% h = waitbar(0,'Computing correlation coefficient and distance matrices...');
% steps=length(A);
% for i=x % for each time point % :length(A)
%     % filter out voxels with more than 10% genes missing
%     isGoodVoxel=(sum(isnan(voxGeneMat{i}),2)<=0.1*length(geneIDInfo{i}));
% %     voxGeneMat_clean{i}=voxGeneMat{i}(isGoodVoxel,:);
%     coOrds_clean{i}=coOrds{i}(isGoodVoxel,:);
%     distMat{i}=squareform(pdist(coOrds_clean{i},'euclidean')*resolutionGrid.(timePoints{i}));
%     %corrCoeffMat{i}=corrcoef((voxGeneMat_clean{i})','rows','pairwise');
%     waitbar(i/steps)
% end
% close(h)
% %clear voxGeneMat
% profreport
% %%
% profile -memory on
% h = waitbar(0,'Computing correlation coefficient and distance matrices...');
% steps=length(A);
% for i=x % for each time point % :length(A)
%     % filter out voxels with more than 10% genes missing
%     isGoodVoxel=(sum(isnan(voxGeneMat{i}),2)<0.1*length(geneIDInfo{i}));
%     voxGeneMat_clean{i}=voxGeneMat{i}(isGoodVoxel,:);
%     %coOrds_clean{i}=coOrds{i}(isGoodVoxel,:);
%     %distMat{i}=squareform(pdist(coOrds_clean{i},'euclidean')*resolutionGrid.(timePoints{i}));
%     
%     % normalize voxel x gene matrix
%     voxGeneMat_clean{i}=BF_NormalizeMatrix(voxGeneMat_clean{i},'scaledSigmoid');
%     corrCoeffMat{i}=corrcoef((voxGeneMat_clean{i})','rows','pairwise');
%     waitbar(i/steps)
% end
% profreport
%%
% extract the correlation coefficients
corrCoeff=geneCorr(find(triu(ones(size(geneCorr)),1)));

distance=distMat(find(triu(ones(size(distMat)),1)));

%% plot coexpression against distance
f=figure('color','w');
gcf;
scatter(distance,corrCoeff,'.')
xlabel('Separation Distance (um)','FontSize',16)
ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',16)
str = sprintf('Developing Mouse %s',timePoints{i});
title(str,'Fontsize',19);
%% fitting

adjRSquare=struct();

fitMethods={'linear','exp_1_0','exp1','exp'};

%%

for j=1:length(fitMethods)
    [~,Stats,c] = GiveMeFit(distance,corrCoeff,fitMethods{j},true);
    adjRSquare.(fitMethods{j})=Stats.adjrsquare;
    confInt.(fitMethods{j})=confint(c,0.95);
    coeffValue.(fitMethods{j})=coeffvalues(c);
end

%%

matAdjRSquare=zeros(length(timePointNow),length(fitMethods)); % +1 because of global
%%
for i=1:length(timePointNow)
    for j=1:length(fitMethods)
        matAdjRSquare(i,j)=adjRSquare.(fitMethods{j})(i);
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

toc