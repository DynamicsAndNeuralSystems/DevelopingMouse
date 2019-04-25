clear
filename='binnedData_numThresholds100.mat';
load(filename);
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
spatialData=struct();
fitting_stat_all=struct();
decayConstant=struct();
maxDistance=struct();
% voxel data
spatialData.voxel.yPlotDataAll=yPlotDataAll;
spatialData.voxel.xPlotDataAll=xPlotDataAll;
spatialData.voxel.numThresholds=numThresholds;
% Initialize
dataType={'voxel'};
for i=1:length(dataType)
    [f, F, fitting_stat_all.(dataType{i}), ...
    decayConstant.(dataType{i}), ...
    maxDistance.(dataType{i})]=getFitting(dataType{i},...
                                spatialData.(dataType{i}).xPlotDataAll,...
                                spatialData.(dataType{i}).yPlotDataAll,...
                                'wholeBrain',...
                                sprintf('binned numThresholds=%d',...
                                        spatialData.(dataType{i}).numThresholds));
    % save figure
    str=fullfile('Outs', 'decay_constant_binned',strcat('decayConstant_binned_',dataType{i},'.jpeg'));
    imwrite(F.cdata,str,'jpeg');
end

%----------------------------------------------------------------------------------------------
% save variables
%----------------------------------------------------------------------------------------------
str=fullfile('Matlab_variables','fitting_binned.mat');
save(str, 'decayConstant', 'maxDistance','fitting_stat_all','spatialData')

%% the following is for scaled x
% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
spatialData=struct();
fitting_stat_all=struct();
decayConstant=struct();
maxDistance=struct();
% voxel data
spatialData.voxel.yPlotDataAll=yPlotDataAll;
spatialData.voxel.xPlotDataAll_scaled=xPlotDataAll_scaled;
spatialData.voxel.numThresholds=numThresholds;
for i=1:length(dataType)
    [f, F, fitting_stat_all.(dataType{i}), ...
    decayConstant.(dataType{i}), ...
    maxDistance.(dataType{i})]=getFitting(dataType{i},...
                                spatialData.(dataType{i}).xPlotDataAll_scaled,...
                                spatialData.(dataType{i}).yPlotDataAll,...
                                'wholeBrain',...
                                sprintf('binned numThresholds=%d',...
                                        spatialData.(dataType{i}).numThresholds));
    % save figure
    str=fullfile('Outs', 'decay_constant_binned_scaled',strcat('decayConstant_binned_scaled_',dataType{i},'.jpeg'));
    imwrite(F.cdata,str,'jpeg');
end

%----------------------------------------------------------------------------------------------
% save variables
%----------------------------------------------------------------------------------------------
str=fullfile('Matlab_variables','fitting_binned_scaled.mat');
save(str, 'decayConstant', 'maxDistance','fitting_stat_all','spatialData')
