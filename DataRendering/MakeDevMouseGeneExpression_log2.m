[structures,Exp,geneEntrez,geneList,timePoints] = LoadData_SDK_full_data_level5('multiple','log2');
cd 'D:\Data\DevelopingAllenMouseAPI-master\Matlab variables'
save('DevMouseGeneExpression_log2.mat','structures','Exp','geneEntrez','geneList','timePoints')