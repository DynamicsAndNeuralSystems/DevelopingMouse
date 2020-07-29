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

% Get fitted Params:
fittedParams = paramFitStruct.(theField).fittedParams;

% Computed CIs:
CIs = paramFitStruct.(theField).CIs;

% Good time points
goodTimePoint = paramFitStruct.(theField).goodTimePoint;

if ~params.includeAdult && (length(fittedParams)==8)
    fittedParams = fittedParams(1:end-1);
    CIs = CIs(1:end-1);
    goodTimePoint = goodTimePoint(1:end-1);
end

% Overwrite params with the stored values from the fit:
params = paramFitStruct.(theField).params;

end
