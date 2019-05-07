% reads in a column of data from excel file
function [data]=readInXLS(filename, range) % range in excel document
if ~exist(filename,'file')
    error('%s is missing',filename)
end
[~,data,~]=xlsread(filename,1,range);
end