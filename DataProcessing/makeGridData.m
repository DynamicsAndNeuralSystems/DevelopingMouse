function [voxGeneMat, distMat, dataIndSelect] = makeGridData(whatTimePointNow, ...
                                                            whatNumData, whatNorm, ...
                                                            whatVoxelThreshold, ...
                                                            thisBrainDiv, cellSpecific)
  % for whatNorm: must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
  % for thisBrainDiv: 'forebrain', 'midbrain' or 'hindbrain'; if left out, all brain divisions included
  % for whatNumData: either input 'all' or the number of voxels to be included
  % if cell specific genes are used, type the cell type in the format of {'cellType','stage'} e.g. {'astrocyte','developing'};
  % otherwise, type 0
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
    filename=strcat('energyGrids_',timePointNow,'.mat');
    load('annotationGrids.mat')
    load('spinalCord_ID.mat')
    load('brainDivision.mat')

    if (iscell(cellSpecific))
      load('enrichedGenes.mat')
      load('geneID_gridExpression.mat')
      if strcmp(cellSpecific{1},'astrocyte')
        if strcmp(cellSpecific{2},'developing')
          geneIDix=cell(length(enrichedGenes.astrocyte.developing),1);
          % compare developing astrocytes gene acronym with gene abbreviation to index into the energy grid needed
          for k=1:length(enrichedGenes.astrocyte.developing)
            geneIDix{k}=cellfun(@(x) strcmp(enrichedGenes.astrocyte.developing,x), geneAbbreviation);
          end
          if nnz(geneIDix{1})==0
            fprintf('No gene available for %s %s in %s',cellSpecific{1},cellSpecific{2},timePointNow);
          else
            load(filename);
            energyGrids=energyGrids(geneIDix{1});
          end
       elseif strcmp(cellSpecific{2},'mature')
          geneIDix=cell(length(enrichedGenes.astrocyte.mature),1);
          % compare developing astrocytes gene acronym with gene abbreviation to index into the energy grid needed
          for k=1:length(enrichedGenes.astrocyte.mature)
            geneIDix{k}=cellfun(@(x) strcmp(enrichedGenes.astrocyte.mature,x), geneAbbreviation);
          end
          if nnz(geneIDix{1})==0
            fprintf('No gene available for %s %s in %s',cellSpecific{1},cellSpecific{2},timePointNow);
          else
            load(filename);
            energyGrids=energyGrids(geneIDix{1});
          end
        end
       elseif strcmp(cellSpecific{1},'oligodendrocyte')
        if strcmp(cellSpecific{2},'progenitor')
          geneIDix=cell(length(enrichedGenes.oligodendrocyte.progenitor),1);
          % compare developing astrocytes gene acronym with gene abbreviation to index into the energy grid needed
          for k=1:length(enrichedGenes.oligodendrocyte.progenitor)
            geneIDix{k}=cellfun(@(x) strcmp(enrichedGenes.oligodendrocyte.progenitor,x), geneAbbreviation);
          end
          if nnz(geneIDix{1})==0
            fprintf('No gene available for %s %s in %s',cellSpecific{1},cellSpecific{2},timePointNow);
          else
            load(filename);
            energyGrids=energyGrids(geneIDix{1});
          end
        elseif strcmp(cellSpecific{2},'postmitotic')
          geneIDix=cell(length(enrichedGenes.oligodendrocyte.postmitotic),1);
          % compare developing astrocytes gene acronym with gene abbreviation to index into the energy grid needed
          for k=1:length(enrichedGenes.oligodendrocyte.postmitotic)
            geneIDix{k}=cellfun(@(x) strcmp(enrichedGenes.oligodendrocyte.postmitotic,x), geneAbbreviation);
          end
          if nnz(geneIDix{1})==0
            fprintf('No gene available for %s %s in %s',cellSpecific{1},cellSpecific{2},timePointNow);
          else
            load(filename);
            energyGrids=energyGrids(geneIDix{1});
          end
        end
      end
    elseif (isnumeric(cellSpecific) & cellSpecific == 0);
      load(filename);
    elseif (isnumeric(cellSpecific) & cellSpecific ~= 0)
      error('numeric cellSpecific must be the number 0')
    elseif ~(isnumeric(cellSpecific)|iscell(cellSpecific))
      error('undefined cellSpecific data type')
    end

    if exist('energyGrids')==1 % if energyGrids is loaded
      %% Create the matrix
      % filters off spinal cord voxels
      isSpinalCord=ismember(annotationGrids{timePointIndex},spinalCord_ID);
      % only keep annotated voxels
      isAnno=annotationGrids{timePointIndex}>0;
      if strcmp(thisBrainDiv,'all')
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
      % for reproducibility
      % rng(0,'twister')
      % s = RandStream('mlfg6331_64');
      % Create distance matrix from only voxels selected for gene expression matrix
      [dataIndSelect,~]=datasample(1:size(voxGeneMat,1),numData,'replace',false);
      distMat=squareform(pdist(coOrds(dataIndSelect,:),'euclidean')...
          *resolutionGrid.(timePointNow));
  else
    voxGeneMat=NaN;
    distMat=NaN;
    dataIndSelect=NaN;
  end
