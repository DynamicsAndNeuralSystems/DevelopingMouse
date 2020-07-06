function createDevMouseGeneExpression()
  % Convert gene expression data into variable structure fields ``raw, norm` and `normGene`
  geneEntrez = xlsread('SDK_geneEntrez.csv');
  [~,geneList,~]  = xlsread('SDK_geneAbbreviations.csv');
  % [structures,Exp,geneEntrez,geneList,timePoints]=LoadData_SDK_full_data_level5('multiple','scaledSigmoid');
  str = fullfile('Matlab_variables','DevMouseGeneExpression.mat');
  save(str,'geneEntrez','geneList')
end
