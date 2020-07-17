function [voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow)
%-------------------------------------------------------------------------------

if nargin < 1
    params = GiveMeDefaultParams();
end

fprintf(1,'Loading voxelwise gene-expression data for %s\n',timePointNow);
fprintf(1,'(%s voxels, %s genes)\n',params.thisBrainDiv,params.thisCellType);

% Get all data for this time point:
theFile = GiveMeFileName(timePointNow);
load(theFile,'coOrds','voxGeneMat','voxLabelTable','geneInfo');

% Take a voxel subset:
if params.doSubsample
    switch params.thisBrainDiv
    case {'brain','wholeBrain'}
        keepMeVoxel = voxLabelTable.sampleBrain;
    case 'forebrain'
        keepMeVoxel = voxLabelTable.sampleForebrain;
    case 'midbrain'
        keepMeVoxel = voxLabelTable.sampleMidbrain;
    case 'hindbrain'
        keepMeVoxel = voxLabelTable.sampleHindbrain;
    case 'Dpall'
        keepMeVoxel = voxLabelTable.sampleDpall;
    end
else
    warning('need to implement non-sample as e.g., ''isHindbrain''')
end

%-------------------------------------------------------------------------------
% Take a gene subset
switch params.thisCellType
case {'all','allCellTypes'}
    keepMeGene = true(height(geneInfo),1);
case 'neuron'
    keepMeGene = geneInfo.isNeuronEnriched;
case 'astrocyte'
    keepMeGene = geneInfo.isAstrocyteEnriched;
case 'oligodendrocyte'
    keepMeGene = geneInfo.isOligodendrocyteEnriched;
end

%-------------------------------------------------------------------------------
% Simple filtering:
[voxelGeneExpression,coOrds,voxInfo,geneInfo] = ApplySubset(keepMeVoxel,keepMeGene,...
                                    voxGeneMat,coOrds,voxLabelTable,geneInfo);

%-------------------------------------------------------------------------------
% Data-based filtering:

% get the proportion of NaN genes of each voxel
% propNanGenes = sum(isnan(voxelGeneExpression),2)/size(voxelGeneExpression,2);
%% only keep good voxels
isGoodVoxel = (mean(isnan(voxelGeneExpression),2) < params.whatVoxelThreshold);
fprintf(1,'%u/%u voxels are good\n',sum(isGoodVoxel),length(isGoodVoxel));
% genes that are not nan in at least a reasonable proportion of voxels:
isGoodGene = (mean(isnan(voxelGeneExpression),1) < params.whatGeneThreshold);
fprintf(1,'%u/%u genes are good\n',sum(isGoodGene),length(isGoodGene));

%-------------------------------------------------------------------------------
% Another subsetting:
[voxelGeneExpression,coOrds,voxInfo,geneInfo] = ApplySubset(isGoodVoxel,isGoodGene,...
                                    voxelGeneExpression,coOrds,voxInfo,geneInfo);

%% normalize matrix
voxelGeneExpression = BF_NormalizeMatrix(voxelGeneExpression,params.whatNorm);

% Checks:
assert(size(voxelGeneExpression,1)==height(voxInfo))
assert(size(voxelGeneExpression,2)==height(geneInfo))
assert(size(coOrds,1)==size(voxelGeneExpression,1))

%-------------------------------------------------------------------------------
function [voxelGeneExpression,coOrds,voxInfo,geneInfo] = ApplySubset(keepRow,keepColumn,...
                                            voxelGeneExpression,coOrds,voxInfo,geneInfo)
    voxelGeneExpression = voxGeneMat(keepRow,keepColumn);
    coOrds = coOrds(keepRow,:);
    voxInfo = voxLabelTable(keepRow,:);
    geneInfo = geneInfo(keepColumn,:);
end

end
