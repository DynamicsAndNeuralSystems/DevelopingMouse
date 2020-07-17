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

switch params.thisBrainDiv
case 'all'
    numVoxels = height(voxLabelTable);
    keepMeVoxel = true(numVoxels,1);
case {'brain','wholeBrain'}
    if params.doSubsample
        keepMeVoxel = voxLabelTable.sampleBrain;
    else
        keepMeVoxel = voxLabelTable.isBrain;
    end
case 'forebrain'
    if params.doSubsample
        keepMeVoxel = voxLabelTable.sampleForebrain;
    else
        keepMeVoxel = voxLabelTable.isForebrain;
    end
case 'midbrain'
    if params.doSubsample
        keepMeVoxel = voxLabelTable.sampleMidbrain;
    else
        keepMeVoxel = voxLabelTable.isMidbrain;
    end
case 'hindbrain'
    if params.doSubsample
        keepMeVoxel = voxLabelTable.sampleHindbrain;
    else
        keepMeVoxel = voxLabelTable.isHindbrain;
    end
case 'Dpall'
    if params.doSubsample
        keepMeVoxel = voxLabelTable.sampleDpall;
    else
        keepMeVoxel = voxLabelTable.isDpall;
    end
otherwise
    error('Unknown region, ''%s''',params.thisBrainDiv);
end

fprintf(1,'Keeping %u %s voxels\n',sum(keepMeVoxel),params.thisBrainDiv);

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
fprintf(1,'Keeping %u %s genes\n',sum(keepMeGene),params.thisCellType);

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
fprintf(1,'Normalizing each gene''s expression as ''%s''\n',params.whatNorm);
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
