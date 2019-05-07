function [voxGeneMat, coOrds, propNanGenes, isGoodGene] = makeGridData(whatTimePointNow, ...
                                                                      whatNorm, ...
                                                                      whatVoxelThreshold,...
                                                                      whatGeneThreshold,...
                                                                      thisBrainDiv,...
                                                                      useGoodGeneSubset)
  % for whatNorm: must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
  % for thisBrainDiv: 'forebrain', 'midbrain', 'hindbrain' or 'wholeBrain'
  % for whatNumData: either input 'all' or the number of voxels to be included
    %% Sets background variables
    % current time point
    timePointNow=whatTimePointNow;
    % matlab variable directory
    varDir=fullfile('Matlab_variables');
    % this script creates a voxel x gene matrix with irrelevant voxels filtered out
    sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],'E18pt5',[67,43,40],'P4',[77,43,50],...
        'P14',[68,40,50],'P28',[73,41,53]);
    timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
    timePointIndex=find(cellfun(@(c)strcmp(timePointNow,c),timePoints)); %match index to the chosen timepoint
    resolutionGrid=struct('E11pt5',80,'E13pt5',100,'E15pt5',120,'E18pt5',140,'P4',160,'P14',200,'P28',200);
    %% load matlab variables
    if useGoodGeneSubset
        filename=strcat('energyGrids_',timePoints{timePointIndex},'.mat');
    else
        filename=strcat('energyGrids_goodGeneSubset',timePoints{timePointIndex},'.mat');
    end
    str=fullfile(varDir,filename);
    load(str)
    load('annotationGrids.mat')
    load('spinalCord_ID.mat')
    load('brainDivision.mat')
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
    % get the annotations
    % annotation_grid=annotationGrids{timePointIndex}(isAnno & ~isSpinalCord & isIncluded);
    % annotation_grid=annotation_grid(isGoodVoxel);
end
