% read in the raw files one by one, registering the 3D position, geneID and expression value
%------------
% Download and unzip the energy grid file for P4 Rora Pdyn SectionDataSet
% -----------
sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
    'P14',[68,40,50],'P28',[73,41,53]);
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
%% load the files
%  grid volume size
sizeGrid = [70,75,40];
resolutionGrid=80;
A=dir('D:\Data\DevelopingAllenMouseAPI-master\API data\GridData');
% remove hidden files
A=A(arrayfun(@(A) A.name(1), A) ~= '.');
% initialize
energyGrids=cell(length(A),1);
timePointInfo=cell(length(A),1);
geneIDInfo=zeros(length(A),1);
for i=1:length(A)
    fileStr=strcat(A(i).name,'/','energy.raw');
    % ENERGY = 3-D matrix of expression energy grid volume
    fid = fopen(fileStr, 'r', 'l' );
    energyGrids{i} = fread( fid, prod(sizeGrid), 'float' );
    fclose( fid );
    energyGrids{i} = reshape(energyGrids{i},sizeGrid);
    infoStr=strsplit(A(i).name,'_');
    timePointInfo{i}=infoStr{1};
    geneIDInfo(i)=str2double(infoStr{2});
end
%% make a distance matrix
%numVoxel=sizeGrid(1)*sizeGrid(2)*sizeGrid(3);
% temporary, for shorter running time
numVoxel=10000;
%geneIDInfo=geneIDInfo(1:100);
ind=1:numVoxel;
[xCoOrd,yCoOrd,zCoOrd]=ind2sub(sizeGrid,ind);
coOrds=zeros(numVoxel,3);
for i=1:numVoxel
    coOrds(i,:)=[xCoOrd(i),yCoOrd(i),zCoOrd(i)];
end
%% compute everything in voxel batches of 10000 to avoid crashes
tic
countVoxel=1;
countLoop=1;
distMat={};
geneMat={};
geneMat_clean=cell(1,1);
distMat_clean=cell(1,1);
geneCorr={};
corrCoeffAll=[];
distanceAll=[];
while countVoxel < numVoxel 
    coOrdsLowRange=countVoxel;
    if (numVoxel-countVoxel)>10000
        coOrdsUpRange=(countVoxel-1)+10000;
    else
        coOrdsUpRange=numVoxel;
    end
    distMat{countLoop}=squareform(pdist(coOrds(coOrdsLowRange:coOrdsUpRange,:),'euclidean')...
        *resolutionGrid);

    % create matrix of voxel x gene expression
    geneMat{countLoop}=zeros(10000,length(geneIDInfo)); 
%     geneMat_clean{countLoop}=zeros(10000,length(geneIDInfo)); 
%     distMat_clean{countLoop}=zeros(10000,length(geneIDInfo)); 
    h = waitbar(0,'Computing voxel x gene expression matrix...');
    steps=length(geneIDInfo);
    for j=1:length(geneIDInfo) % for each gene (i.e. each 3D grid)
        for k=1:10000 % for each voxel
            % replace negative gene expression values with NaN (because -1 indicate absent data)
            isAbsent=(energyGrids{j}(coOrdsLowRange+(k-1))<0);
            if isAbsent
                geneMat{countLoop}(k,j)=NaN;
            else
                geneMat{countLoop}(k,j)=energyGrids{j}(coOrdsLowRange+(k-1));
            end
        end
        waitbar(j/steps)
    end
    close(h)
    % filter off voxels with more than 90% gene missing
    geneMissing=(sum(~isnan(geneMat{countLoop}),2) <= 0.9*length(geneIDInfo));
    if nnz(geneMissing)>0.95*numVoxel
        error('More than 95% of the voxels have more than 90% gene missing, cannot proceed')
    end
    geneMat_clean{countLoop}=geneMat{countLoop}(~isMissing,:);
    distMat_clean{countLoop}=distMat{countLoop}(~isMissing,:);
    % compute the gene coexpression between voxels
    geneCorr{countLoop}=corrcoef((geneMat_clean{countLoop})','rows','pairwise');
    
    % extract the correlation coefficients
    corrCoeff=[];
    h = waitbar(0,'Extracting correlation coefficients...');
    steps=size(geneCorr{countLoop},2)-1;
    for g=2:size(geneCorr{countLoop},2)
        corrCoeff=[corrCoeff;geneCorr{countLoop}(1:(g-1),g)];
        waitbar((g-1)/steps)
    end
    close(h)
    % extract the distances
    distance=distMat_clean{countLoop}(find(triu(distMat_clean{countLoop},1)));

    % filter off data points with NaN in gene coexpression
    isMissing=isnan(corrCoeff);
    corrCoeff_clean=corrCoeff(~isMissing);
    distance_clean=distance(~isMissing);
    
    corrCoeffAll=[corrCoeffAll;corrCoeff_clean];
    distanceAll=[distanceAll;distance_clean];
    % increment the counting variables   
    countVoxel=countVoxel+10000;
    countLoop=countLoop+1;
end
toc    
%%
f=figure('color','w');
scatter(distance_clean,corrCoeff_clean,'.')

%     h = waitbar(0,'Extracting distances...');
%     steps=size(distMat{countLoop},2)-1;
%     for g=2:size(distMat{countLoop},2)
%         distance=[distance;distMat{countLoop}(1:(g-1),g)];
%         waitbar((g-1)/steps)
%     end
%      close(h)
    % add the distance and correlation coefficients to the global variable
