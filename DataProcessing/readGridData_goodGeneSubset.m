function readGridData_goodGeneSubset(whatTimePointNow)
%%
fileTimePoints={'E11.5','E13.5','E15.5','E18.5','P4','P14','P28'};
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
timePointIndex=find(cellfun(@(c)strcmp(whatTimePointNow,c),timePoints)); %match index to the chosen timepoint
sizeGrids=struct('E11pt5',[70,75,40],'E13pt5',[89,109,69],'E15pt5',[94,132,65],...
                'E18pt5',[67,43,40],'P4',[77,43,50],'P14',[68,40,50],'P28',[73,41,53]);
%% specify directories
% Location of saved API gene expression data expressed in a cell
expression_loc=fullfile('Data','API','GridData',fileTimePoints{timePointIndex});
%%
load('goodGeneSubset.mat','goodGeneSubset')

energyGrids=cell(length(goodGeneSubset),1);
geneIDInfo=zeros(length(goodGeneSubset),1);

% store original directory and move to new directory (necessitated by
% filepath problems)
currentFolder = pwd;
cd(expression_loc);

h = waitbar(0,'Compiling energy grid...');
steps=length(goodGeneSubset);
%%
for j=1:length(goodGeneSubset)
    fileStr=fullfile(strcat(fileTimePoints{timePointIndex},'_',...
                    num2str(goodGeneSubset{j})),'energy.raw');
    % ENERGY = 3-D matrix of expression energy grid volume
    % load files
    fid = fopen(fileStr, 'r', 'l' );
    energyGrids{j} = fread( fid, prod(sizeGrids.(timePoints{timePointIndex})), 'float' );
    fclose( fid );
    energyGrids{j} = reshape(energyGrids{j},sizeGrids.(timePoints{timePointIndex}));
    waitbar(j/steps)
end

close(h)

%% redirect to home directory
cd(currentFolder);
%%

var_name1=strcat('energyGrids_goodGeneSubset_',timePoints{timePointIndex},'.mat');
str=fullfile('Matlab_variables',var_name1);
save(str,'energyGrids','-v7.3')

var_name2=strcat('geneIDInfo_goodGeneSubset_',timePoints{timePointIndex},'.mat');
str=fullfile('Matlab_variables',var_name2);
save(str,'geneIDInfo')

end
