% Add paths required for the project (ignoring hidden, including version control)
cd(fileparts(which(mfilename)))
files = dir;
directories = files([files.isdir]);
directories(strmatch('.',{files([files.isdir]).name})) = []; % remove hidden
directories(strmatch('Data',{files([files.isdir]).name})) = []; % remove data for the time being
paths = arrayfun(@(x)fullfile(directories(x).name),1:length(directories),'UniformOutput',false);
for j = 1:length(paths)
    addpath(genpath(paths{j}))
end
