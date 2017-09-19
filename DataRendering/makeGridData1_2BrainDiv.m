% user input the value of i (1=E11.5; 2=E13.5; 3=E15.5; 4=E18.5; 5=P4;
% 6=P14; 7=P28)
i=1;
% user input: number of data used in analysis
numData=587;
% user input: current time point
timePointNow={'E11pt5'};

% this script creates a voxel x gene matrix with irrelevant voxels filtered out
sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

resolutionGrid=struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,...
    'P14',200,'P28',200);
%% load variables
% load('timePointInfo.mat')
% load('geneIDInfo.mat')
load('annotationGrids.mat')
load('spinalCordID.mat')
load('foreBrain_ID.mat')
load('midBrain_ID.mat')
load('hindBrain_ID.mat')
brainDivision={'foreBrain','midBrain','hindBrain'};
brainDivisionID=struct('foreBrain',foreBrain_ID,'midBrain',midBrain_ID,'hindBrain',hindBrain_ID);

%%
tic
% find all combinations of 2 brain divisions
v=1:3;
C=combnk(v,2);

% loop through the brain divisions
for d=1:size(C,1)
    % load gene expression energy grid
    str=strcat('energyGrids_',timePoints{i},'.mat');
    load(str)
    % filters
    isSpinalCord=ismember(annotationGrids{i},spinalCord_ID);
    isAnno=annotationGrids{i}>0;
    combNow1=C(d,1);
    combNow2=C(d,2);
    isBrainDivision1=ismember(annotationGrids{i},brainDivisionID.(brainDivision{combNow1}));
    isBrainDivision2=ismember(annotationGrids{i},brainDivisionID.(brainDivision{combNow2}));
    % create coordinates
    [a,b,c]=ind2sub(sizeGrids.(timePoints{i}),find(isAnno & ~isSpinalCord & isBrainDivision1));
    coOrds1=horzcat(a,b,c);
    [a,b,c]=ind2sub(sizeGrids.(timePoints{i}),find(isAnno & ~isSpinalCord & isBrainDivision2));
    coOrds2=horzcat(a,b,c);
    % make voxel x gene matrix

    voxGeneMat1=zeros(nnz(isAnno & ~isSpinalCord & isBrainDivision1),length(energyGrids));
    voxGeneMat2=zeros(nnz(isAnno & ~isSpinalCord & isBrainDivision2),length(energyGrids));

    h = waitbar(0,'Computing first voxel x gene expression matrix...');
    steps=length(energyGrids);
    for j=1:size(voxGeneMat1,2) % for each gene
        energyGridsNow=energyGrids{j};
        energyGridsNow1=energyGridsNow(isAnno & ~isSpinalCord & isBrainDivision1);
        
        for k=1:size(voxGeneMat1,1) % for each voxel
            if energyGridsNow1(k)<0
               voxGeneMat1(k,j)=NaN;
            else
               voxGeneMat1(k,j)=energyGridsNow1(k);
            end
        end
        waitbar(j/steps)
    end
    close(h)
    
    h = waitbar(0,'Computing second voxel x gene expression matrix...');    
    for j=1:size(voxGeneMat2,2) % for each gene
        energyGridsNow=energyGrids{j};
        energyGridsNow2=energyGridsNow(isAnno & ~isSpinalCord & isBrainDivision2);
        
        for k=1:size(voxGeneMat2,1) % for each voxel
            if energyGridsNow2(k)<0
               voxGeneMat2(k,j)=NaN;
            else
               voxGeneMat2(k,j)=energyGridsNow2(k);
            end
        end
        waitbar(j/steps)
    end
    close(h)    

    
    %% only keep good voxels
    % for matrix 1
    isGoodVoxel=(sum(isnan(voxGeneMat1),2) < 0.3*size(voxGeneMat1,2));

    voxGeneMat1=voxGeneMat1(isGoodVoxel,:);
    coOrds1=coOrds1(isGoodVoxel,:);
    % normalize
    voxGeneMat1=BF_NormalizeMatrix(voxGeneMat1,'scaledSigmoid');
    % for matrix 2
    isGoodVoxel=(sum(isnan(voxGeneMat2),2) < 0.3*size(voxGeneMat2,2));

    voxGeneMat2=voxGeneMat2(isGoodVoxel,:);
    coOrds2=coOrds2(isGoodVoxel,:);
    % normalize
    voxGeneMat2=BF_NormalizeMatrix(voxGeneMat2,'scaledSigmoid');
    
    %%
    if numData>size(voxGeneMat1,1)
        error('matrix 1: number of data analyzed cannot be larger than number of available voxels')
    end

    if numData>size(voxGeneMat2,1)
        error('matrix 2: number of data analyzed cannot be larger than number of available voxels')
    end
    
    [dataIndSelect1,~]=datasample([1:size(voxGeneMat1,1)],numData,'replace',false);
    voxGeneMat1=voxGeneMat1(dataIndSelect1,:); % select only a portion for analysis
    %geneCorr=corrcoef((voxGeneMat1(dataIndSelect,:))','rows','pairwise');
    [dataIndSelect2,~]=datasample([1:size(voxGeneMat2,1)],numData,'replace',false);
    voxGeneMat2=voxGeneMat2(dataIndSelect2,:); % select only a portion for analysis
    
    % make a correlation coefficient matrix using the 1000 voxels from each of the voxGeneMat
    geneCorr=zeros(numData,numData);
    % compute correlation coefficient
    h = waitbar(0,'Computing correlation coefficient matrix...');
    steps=size(geneCorr,1) ;
    for k=1:size(geneCorr,1) 
        for q=1:size(geneCorr,2)
            tempMat=corrcoef(voxGeneMat1(k,:)',voxGeneMat2(q,:)','rows','pairwise');
            geneCorr(k,q)=tempMat(1,2);
        end
        waitbar(k/steps)
    end
    close(h)

    distMat=pdist2(coOrds1(dataIndSelect1,:),coOrds2(dataIndSelect2,:),'euclidean')*resolutionGrid.(timePoints{i});
    
    
    
    %%
    % extract the correlation coefficients
    corrCoeff=geneCorr(:);
    distance=distMat(:);
    
    %% plot coexpression against distance
    f=figure('color','w');
    scatter(distance,corrCoeff,'.')
    xlabel('Separation Distance (um)','FontSize',16)
    ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
    str = sprintf('Developing Mouse %s %s %s',timePoints{i},brainDivision{combNow1},brainDivision{combNow2});
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
        str=sprintf('Degree of freedom adjusted R-square, scaled sigmoid, %s %s',brainDivision{combNow1},brainDivision{combNow2});
    else
        str=sprintf('Degree of freedom adjusted R-square, %s %s %s',whatNorm, brainDivision{combNow1},brainDivision{combNow2});
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
    str = sprintf('Developing Mouse %s %s %s',timePoints{i},brainDivision{combNow1},brainDivision{combNow2});
    title(str,'Fontsize',19);
    w=figureFullScreen(w,true); 
    
    clear energyGrids


    %% save variables and figures

    cd '/projects/kg98/Gladys/Output/makeGridData1_2BrainDiv_fig'
    str=strcat('GeneCoexpress_',timePoints{i},brainDivision{combNow1},brainDivision{combNow2},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
    saveas(f,str)
    str=strcat('R-square_exp_voxel_',timePoints{i},brainDivision{combNow1},brainDivision{combNow2},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
    saveas(g,str)
    str=strcat('expoFit_voxel_',timePoints{i},brainDivision{combNow1},brainDivision{combNow2},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
    saveas(w,str)
    clear f
    clear g
    clear w
    cd '/projects/kg98/Gladys/Output/makeGridData1_2BrainDiv_var'
    str=strcat('makeGridData1_2BrainDiv',timePoints{i},brainDivision{combNow1},brainDivision{combNow2},'.mat');
    save(str,'-v7.3')
end

%%
toc
