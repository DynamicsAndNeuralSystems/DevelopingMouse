function [params,fittedParams,CIs,goodTimePoint] = LoadParameterFits(params)

if ~params.doSubsample
    theFileName = 'parameterFits.mat';
else
    theFileName = 'parameterFits_subsampled.mat';
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
