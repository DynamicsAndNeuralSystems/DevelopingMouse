% iterate through the folders storing grid expression data to retrieve the gene IDs
geneID_gridExpression=struct();
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
fileTimePoints={'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'};
for i=1:length(timePoints)
  str=fullfile('Data','API','GridData',fileTimePoints{i});
  A=dir(str);
  % remove hidden files
  A=A(arrayfun(@(A) A.name(1), A) ~= '.');
  % initialize variables
  geneID_gridExpression.(timePoints{i})=cell(length(A),1);
  for j=1:length(A)
    infoStr=strsplit(A(j).name,'_');
    geneID_gridExpression.(timePoints{i}){j}=str2double(infoStr{2});
  end
end
% save variables
str=fullfile('Matlab_variables','geneID_gridExpression.mat');
save(str,'geneID_gridExpression');
