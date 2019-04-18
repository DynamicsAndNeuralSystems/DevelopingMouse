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
        addpath(paths{j})
    else
        % add any nested subdirectories
        addpath(genpath(paths{j}));
    end
end
