cd 'D:\Data\DevelopingAllenMouseAPI-master\Rubinov regions_all genes\Data'
[structures,structuresNeed,Exp,geneEntrez,geneList,timePoints]=LoadData_SDK_full_data('multiple','scaledSigmoid');
cd 'D:\Data\DevelopingAllenMouseAPI-master\API data'
save('DevMouseGeneExpression_Rubinov.mat','structures','structuresNeed','Exp','geneEntrez','geneList','timePoints')
