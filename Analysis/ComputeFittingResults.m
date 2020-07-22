function ComputeFittingResults(doSubsample)
% Do the exponential parameter fitting

%-------------------------------------------------------------------------------
params = GiveMeDefaultParams();
params.doSubsample = doSubsample;
params.thisCellType = 'allCellTypes';
%-------------------------------------------------------------------------------
% Vary over brain divisions
brainDivs = {'brain','forebrain','midbrain','hindbrain','Dpall'};
numBrainDivs = length(brainDivs);
%-------------------------------------------------------------------------------

for b = 1:numBrainDivs
    params.thisBrainDiv = brainDivs{b};

    %-------------------------------------------------------------------------------
    % Curve fitting
    %-------------------------------------------------------------------------------
    numTimePoints = length(params.timePoints);
    goodTimePoint = false(numTimePoints,1);
    stats = cell(numTimePoints,1);
    fittedParams = cell(numTimePoints,1);
    for i = 1:numTimePoints
        % Load the distance, CGE data:
        [dist,CGE] = ComputeDistanceCGE(params,params.timePoints{i},true);
        if isnan(dist)
            continue
        else
            goodTimePoint(i) = true;
        end

        % Bin the data:
        [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist,CGE,params.numThresholds);

        % Fit the binned data (on means):
        [fitHandle,stats{i},fittedParams{i}] = GiveMeFit(xBinCenters,yMeans,params.whatFit,true);
    end

    %-------------------------------------------------------------------------------
    % Convert to confidence intervals:
    CIs = cellfun(@(x)confint(x),fittedParams,'UniformOutput',false);
    % ***Convert n -> inverses (hopefully valid to do nonlinear transformations of CIs)***
    nIndex = strcmp(paramNames,'n');
    for i = 1:length(CIs)
        CIs{i}(:,nIndex) = 1./CIs{i}(:,nIndex);
    end

    %-------------------------------------------------------------------------------
    %-------------------------------------------------------------------------------
    if ~params.doSubsample
        theFileName = 'parameterFits.mat';
    else
        theFileName = 'parameterFits_subsampled.mat';
    end
    if ~(exist(theFileName,'file')==0)
        paramFitStruct = struct();
    else
        load(theFileName,'paramFitStruct')
    end

    theField = sprintf('%s_%s',params.thisBrainDiv,params.thisCellType);
    paramFitStruct.(theField).params = params;
    paramFitStruct.(theField).stats = stats;
    paramFitStruct.(theField).fittedParams = fittedParams;
    paramFitStruct.(theField).paramNames = paramNames;
    paramFitStruct.(theField).goodTimePoint = goodTimePoint;
    paramFitStruct.(theField).CIs = CIs;
    fprintf(1,'Saving fitted info back to %s\n',theFileName);

    if ~(exist(theFileName,'file')==0)
        save(theFileName,'paramFitStruct','-append');
    else
        save(theFileName,'paramFitStruct');
    end
    fprintf(1,'Saved parameter fitting results to %s:%s\n',theFileName,theField);
end

end