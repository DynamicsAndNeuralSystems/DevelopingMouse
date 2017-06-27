% load data
[structures,Exp,geneEntrez,geneList,timePoints] = LoadData_SDK_full_data_level5('multiple','scaledSigmoid');
save('DevMouseGeneExpression.mat','structures','Exp','geneEntrez','geneList','timePoints')