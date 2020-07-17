

params = GiveMeDefaultParams();
params.thisBrainDiv = 'all';
[voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,'E11pt5');

ord_row = BF_ClusterReorder(voxelGeneExpression,'euclidean','average');
ord_col = BF_ClusterReorder(voxelGeneExpression','euclidean','average');
imagesc(voxelGeneExpression(ord_row,ord_col))
colormap(BF_getcmap('redyellowblue',11,0))
