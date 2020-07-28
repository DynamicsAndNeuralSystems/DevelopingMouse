function [params,fittedParams,CIs,goodTimePoint] = LoadParameterFits(params)
% Need parameter fitting to be performed using ComputeFittingResults
%-------------------------------------------------------------------------------
if nargin < 1
    params = GiveMeDefaultParams();
end

if ~params.doSubsample
    theFileName = 'parameterFits.mat';
else
    theFileName = 'parameterFits_subsampled.mat';
end

if ~exist(theFileName)
    error('Run ComputeFittingResults to save parameter fitting results');
end
load(theFileName,'paramFitStruct')
theField = sprintf('%s_%s',params.thisBrainDiv,params.thisCellType);
if ~isfield(paramFitStruct,theField)
    error('Incomplete computation in %s: missing %s',theFileName,theField);
end

% Overwrite params with the stored values from the fit:
params = paramFitStruct.(theField).params;

% Get fitted Params:
fittedParams = paramFitStruct.(theField).fittedParams;

% Computed CIs:
CIs = paramFitStruct.(theField).CIs;

% Good time points
goodTimePoint = paramFitStruct.(theField).goodTimePoint;

end
