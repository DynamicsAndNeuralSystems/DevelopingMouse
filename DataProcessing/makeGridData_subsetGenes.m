function [voxGeneMat, distMat, dataIndSelect] = makeGridData_subsetGenes(whatTimePointNow, ...
                                                            whatNumData, whatNorm, ...
                                                            whatVoxelThreshold, ...
                                                            thisBrainDiv, geneIDs)
  % for whatNorm: must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
  % for thisBrainDiv: 'forebrain', 'midbrain' or 'hindbrain'; if left out, all brain divisions included
  % for whatNumData: either input 'all' or the number of voxels to be included
  % for geneIDs: a cell containing IDs of genes to be included in making the voxGeneMat
    %% Sets background variables
    % current time point
    timePointNow=whatTimePointNow;
    % % change thisBrainDiv to a cell for later referencing use
    % thisBrainDiv_cell=cell(1,1);
    % thisBrainDiv_cell{1}=thisBrainDiv;
    % this script creates a voxel x gene matrix with irrelevant voxels filtered out
    sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
        'P14',[68,40,50],'P28',[73,41,53]);
    timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
    timePointIndex=find(cellfun(@(c)strcmp(timePointNow,c),timePoints)); %match index to the chosen timepoint
    resolutionGrid=struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,...
        'P14',200,'P28',200);
    %% load matlab variables
    filename=strcat('energyGrids_',timePoints{timePointIndex},'.mat');
    load(filename)
    load('annotationGrids.mat')
    load('spinalCord_ID.mat')
    load('brainDivision.mat')
    load(strcat('geneIDInfo_',timePoints{timePointIndex},'.mat'))
    %% Create the matrix
    % filters off spinal cord voxels
    isSpinalCord=ismember(annotationGrids{timePointIndex},spinalCord_ID);
    isAnno=annotationGrids{timePointIndex}>0;
    % if nargin<5 % all brain divisions
    %     isIncluded=union(union(ismember(annotationGrids{timePointIndex},brainDivision.forebrain.ID),...
    %                     ismember(annotationGrids{timePointIndex},brainDivision.midbrain.ID)),...
    %                     ismember(annotationGrids{timePointIndex},brainDivision.hindbrain.ID));
    % else % only a particular brain division
    if strcmp(thisBrainDiv,'all')
        isIncluded=or(or(ismember(annotationGrids{timePointIndex},brainDivision.forebrain.ID),...
                          ismember(annotationGrids{timePointIndex},brainDivision.midbrain.ID)),...
                          ismember(annotationGrids{timePointIndex},brainDivision.hindbrain.ID));
    elseif strcmp(thisBrainDiv,'forebrain')
      isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.forebrain.ID);
    elseif strcmp(thisBrainDiv,'midbrain')
      isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.midbrain.ID);
    elseif strcmp(thisBrainDiv,'hindbrain')
      isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.hindrain.ID);
    else
      error('Invalid brain division input')
    end
    % turn geneIDs into a vector
    geneIDs=cellfun(@(x) {x}, geneIDs);
    % get the index of genes to be included
    ixGeneSubset=find(ismember(geneIDInfo,geneIDs));
    % make voxel x gene matrix
    voxGeneMat=zeros(nnz(isAnno & ~isSpinalCord & isIncluded),length(geneIDs));

    h = waitbar(0,'Computing voxel x gene expression matrix...');
    steps=size(voxGeneMat,2);
    for j=1:size(voxGeneMat,2) % for each gene
        energyGridsNow=energyGrids{ixGeneSubset(j)};
        energyGridsNow=energyGridsNow(isAnno & ~isSpinalCord & isIncluded);
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
    isGoodVoxel=(sum(isnan(voxGeneMat),2) < whatVoxelThreshold*size(voxGeneMat,2));
    voxGeneMat=voxGeneMat(isGoodVoxel,:);

    %% normalize matrix
    voxGeneMat=BF_NormalizeMatrix(voxGeneMat,whatNorm); % 'scaledSigmoid' used in Monash analysis

    % number of data used in analysis
    if isnumeric(whatNumData)
        numData=whatNumData; % 1000 used in Monash analysis
        % Check against error
        if numData>size(voxGeneMat,1)
            error('number of data analyzed cannot be larger than number of available voxels')
        end
    elseif strcmp(whatNumData,'all')
        numData=size(voxGeneMat,1);
    else
        error('Invalid numData input')
    end
    %% create coordinates and compute distance matrix
    % get all coordinates
    [a,b,c]=ind2sub(sizeGrids.(timePoints{timePointIndex}),find(isAnno & ~isSpinalCord & isIncluded));
    coOrds=horzcat(a,b,c);
    % only keep good voxels
    coOrds=coOrds(isGoodVoxel,:);
    % Create distance matrix from only voxels selected for gene expression matrix
    [dataIndSelect,~]=datasample([1:size(voxGeneMat,1)],numData,'replace',false);
    distMat=squareform(pdist(coOrds(dataIndSelect,:),'euclidean')*resolutionGrid.(timePoints{timePointIndex}));
end
