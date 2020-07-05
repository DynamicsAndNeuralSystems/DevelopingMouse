function makeBrainDivision()
% initialize

brainDivision=struct();
% divisions={'forebrain','midbrain','hindbrain'};
brainDivisions = GiveMeParameter('createBrainDivisions');
brainDivisionsAbbrev = GiveMeParameter('createBrainDivisionsAbbrev');
descendantCsvDim = GiveMeParameter('descendantCsvDim');
for i=1:length(brainDivisions)
  brainDivision.(brainDivisions{i}).ID=csvread(strcat('structure_',brainDivisionsAbbrev{i},...
                                                      '_descendant_ID.csv'),1,1,...
                                                      descendantCsvDim{i});
end

str=fullfile('Matlab_variables','brainDivision.mat');
save(str,'brainDivision')

end
