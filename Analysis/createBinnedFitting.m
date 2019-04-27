% initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
filestr='binnedData_NumData_1000_numThresholds_100';
load(strcat(filestr,'.mat'));
file_parts=strsplit(filestr,'_');
NumData=file_parts{3};
NumThresholds=file_parts{5};
% create fitting
[fitting_stat_all, decayConstant, maxDistance]=getFitting(xPlotDataAll,yPlotDataAll);
str=fullfile('Matlab_variables',strcat('fitting_NumData_',NumData,'_',...
                                        'binnedData_numThresholds_',NumThresholds,'.mat'));
save(str,'fitting_stat_all','decayConstant','maxDistance');

% create fitting (scaled x distance)
[fitting_stat_all, decayConstant, ~]=getFitting(xPlotDataAll_scaled,yPlotDataAll);
str=fullfile('Matlab_variables',strcat('fitting_NumData_',NumData,'_',...
                                        'binnedData_numThresholds_',NumThresholds,'_scaled','.mat'));
save(str,'fitting_stat_all','decayConstant','maxDistance'); % save max distance of original
