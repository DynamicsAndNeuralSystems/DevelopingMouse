whichField={'norm'};
% user input: the percentage of genes missing above which to filter a structure
filterThreshold = 0.9;
load('dataDevMouse.mat')
load('DevMouseGeneExpression.mat')
[acronym,~]=importfile_AcronymPath_level5('AcronymPath_level5.csv')
% create time(7) x 2100 (genes) x 78 (structure) matrix
gene3D=MakeMatrix(Exp.Energy.(whichField{1}));
% Initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
voxGeneMat_structure=cell(length(timePoints),1);
acronyms=cell(length(timePoints),1);
for i=1:length(timePoints) % for each time point
    slice=squeeze(gene3D(i,:,:)); % makes a matrix of 78 (structure) x 2100 (genes)
    % filter off structures with more than a certain threshold % of genes missing
    isMissing=((sum(isnan(slice),1)) >= (filterThreshold*length(geneList)));
    slice_clean=slice(:,~isMissing);
    % match the structure regions (because not all time points have all region coordinates available)
    [~,ia,ib]=intersect(char(structures(~isMissing)),...
                        dataDevMouse.(timePoints{i}).acronym,'stable');
    % [~,ix,iy]=intersect(char(structures(~isMissing)),acronym,'stable');
    % only structures in which coordinates are available are used
    slice_clean=slice_clean(:,ia);
    voxGeneMat_structure{i}=slice_clean;
    % get the structure labels
    acronyms{i}=dataDevMouse.(timePoints{i}).acronym(ib);
end
% save variables
str=fullfile('Matlab_variables','voxGeneMat_structures_all.mat');
save(str,'voxGeneMat_structure','acronyms')
