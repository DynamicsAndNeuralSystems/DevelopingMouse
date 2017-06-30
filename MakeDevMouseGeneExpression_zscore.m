[structures,Exp,geneEntrez,geneList,timePoints] = LoadData_SDK_full_data_level5('multiple','zscore');
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
save('DevMouseGeneExpression_zscore.mat','structures','Exp','geneEntrez','geneList','timePoints')

