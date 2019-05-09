function makeGeneList_gridExpression()
% iterate through the folders storing grid expression data to retrieve the gene IDs
geneID_gridExpression=struct();
timePoints=GiveMeParameter('timePoints');
fileTimePoints=GiveMeParameter('fileTimePoints');
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
end
