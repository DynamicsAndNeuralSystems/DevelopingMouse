function [voxGeneMat, coOrds, propNanGenes, isGoodGene] = makeGridData(timePointNow, ...
                                                                      whatNorm, ...
                                                                      whatVoxelThreshold,...
                                                                      whatGeneThreshold,...
                                                                      thisBrainDiv)
  % this script creates a voxel x gene matrix with irrelevant voxels filtered out
  % for whatNorm: must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
  % for thisBrainDiv: 'forebrain', 'midbrain', 'hindbrain' or 'wholeBrain'
  % for whatNumData: either input 'all' or the number of voxels to be included
    %% Sets background variables
    sizeGrids = GiveMeParameter('sizeGrids');
    timePoints = GiveMeParameter('timePoints');
    resolutionGrid = GiveMeParameter('resolutionGrid');
    timePointIndex = GiveMeParameter('timePointIndex'); %match index to the chosen timepoint

    %% load matlab variables
    filename=sprintf('energyGrids_%s.mat',timePoints{timePointIndex});
    load(str)
    load('annotationGrids.mat','annotationGrids')
    load('spinalCord_ID.mat','spinalCord_ID')
    load('brainDivision.mat','brainDivision')
    %% Create the matrix
    % filters off spinal cord voxels
    isSpinalCord=ismember(annotationGrids{timePointIndex},spinalCord_ID);
    isAnno=annotationGrids{timePointIndex}>0;

    if strcmp(thisBrainDiv,'wholeBrain')
        isIncluded=or(or(ismember(annotationGrids{timePointIndex},brainDivision.forebrain.ID),...
                          ismember(annotationGrids{timePointIndex},brainDivision.midbrain.ID)),...
                          ismember(annotationGrids{timePointIndex},brainDivision.hindbrain.ID));
    elseif strcmp(thisBrainDiv,'forebrain')
      isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.forebrain.ID);
    elseif strcmp(thisBrainDiv,'midbrain')
      isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.midbrain.ID);
    elseif strcmp(thisBrainDiv,'hindbrain')
      isIncluded=ismember(annotationGrids{timePointIndex},brainDivision.hindbrain.ID);
    else
      error('Invalid brain division input')
    end
    % end
    % make voxel x gene matrix
    voxGeneMat=zeros(nnz(isAnno & ~isSpinalCord & isIncluded),length(energyGrids));

    h = waitbar(0,'Computing voxel x gene expression matrix...');
    steps=length(energyGrids);
    for j=1:size(voxGeneMat,2) % for each gene
        energyGridsNow=energyGrids{j};
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

    % get the proportion of NaN genes of each voxel
    propNanGenes=sum(isnan(voxGeneMat),2)/size(voxGeneMat,2);
    % index of genes that are not nan in at least a reasonable proportion of voxels
    isGoodGene=(sum(isnan(voxGeneMat),1) < whatGeneThreshold*size(voxGeneMat,1));

    %% only keep good voxels
    isGoodVoxel=(sum(isnan(voxGeneMat),2) < whatVoxelThreshold*size(voxGeneMat,2));
    voxGeneMat=voxGeneMat(isGoodVoxel,:);

    %% normalize matrix
    voxGeneMat=BF_NormalizeMatrix(voxGeneMat,whatNorm); % 'scaledSigmoid' used in Monash analysis

    % get all coordinates
    [a,b,c]=ind2sub(sizeGrids.(timePoints{timePointIndex}),find(isAnno & ~isSpinalCord & isIncluded));
    coOrds=horzcat(a,b,c);
    % only keep good voxels
    coOrds=coOrds(isGoodVoxel,:);
end
