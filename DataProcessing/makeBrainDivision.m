function makeBrainDivision()
% Save brain division ID information to matlab file (from raw csv data)
%-------------------------------------------------------------------------------

brainDivisions = GiveMeParameter('createBrainDivisions');
brainDivisionsAbbrev = GiveMeParameter('createBrainDivisionsAbbrev');
descendantCsvDim = GiveMeParameter('descendantCsvDim');

brainDivision = struct();
for i = 1:length(brainDivisions)
    brainDivision.(brainDivisions{i}).ID = csvread(strcat('structure_',brainDivisionsAbbrev{i},...
                                                      '_descendant_ID.csv'),1,1,...
                                                      descendantCsvDim{i});
end

fileOut = fullfile('Matlab_variables','brainDivision.mat');
save(fileOut,'brainDivision')
fprintf(1,'Saved processed brain division information to %s\n',fileOut);

end
