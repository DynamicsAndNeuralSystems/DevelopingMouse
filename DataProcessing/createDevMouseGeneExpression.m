% Convert gene expression data into variable structure fields ``raw, norm` and `normGene`
[structures,Exp,geneEntrez,geneList,timePoints]=LoadData_SDK_full_data_level5('multiple','scaledSigmoid');
str = fullfile('Data', 'Matlab_variables','DevMouseGeneExpression.mat');
save(str,'structures','Exp','geneEntrez','geneList','timePoints')
