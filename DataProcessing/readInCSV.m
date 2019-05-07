function [dataArray]=readInCSV(filename,formatSpec)
% Check for file existence
if ~exist(filename,'file')
    error('file is missing')
end
% Initialize variables
delimiter = ',';
startRow = 2;

% read the file for acronym and color
fileID = fopen(filename,'r');
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
end