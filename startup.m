% Add paths required for the project (ignoring hidden, including version control)
%%
files = dir;
directories = files([files.isdir]);
directories(strmatch('.',{files([files.isdir]).name})) = []; % remove hidden
%%
% directories(strmatch('Data',{files([files.isdir]).name})) = []; % remove Data
%%
paths = arrayfun(@(x)fullfile(directories(x).name),1:length(directories),'UniformOutput',false);
%%
for j = 1:length(paths)
    if strcmp(paths{j},'Data')
        % no nested subdirectories
        addpath(paths{j});
        % add path to a directory containing allen data
        addpath(fullfile('Data','API','Structures'));
        addpath(fullfile('Data','API','Unionizes'));
        addpath(fullfile('Data','API','Filtering'));
        addpath(fullfile('Data','API','GridData'));
        % add path to a directory containing other raw data
        addpath(fullfile('Data','Others'));
        % Figshare data
        % addpath(fullfile('Data','Figshare'));
    else
        % add any nested subdirectories
        addpath(genpath(paths{j}));
    end
end
