function f = makeConstantPlot(params)
% Plot variation of fitted parameters over time
%-------------------------------------------------------------------------------

% Load the distance, CGE data:
[dist,CGE] = LoadMyDistanceCGE(params);

%-------------------------------------------------------------------------------
% Curve fitting
%-------------------------------------------------------------------------------
numTimePoints = length(params.timePoints);
stats = cell(numTimePoints,1);
fittedParams = cell(numTimePoints,1);
for i = 1:numTimePoints
  % Bin the data:
  [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist{i},CGE{i},params.numThresholds);

  % Fit the binned data (on means):
  [fitHandle,stats{i},fittedParams{i}] = GiveMeFit(xBinCenters,yMeans,params.whatFit,true);
end

paramNames = coeffnames(fittedParams{1});

% Convert to confidence intervals:
CIs = cellfun(@(x)confint(x),fittedParams,'UniformOutput',false);
% ***Convert n -> inverses (probably invalid to do nonlinear transformations of CIs)***
nIndex = strcmp(paramNames,'n');
for i = 1:numTimePoints
    CIs{i}(:,nIndex) = 1./CIs{i}(:,nIndex);
end

% Get max distances
maxDistances = makeMaxDistance(params);

%-------------------------------------------------------------------------------
% Plotting
%-------------------------------------------------------------------------------
doLogLambda = true;
if doLogLambda
    customParamOrder = {'n','nLog','A','B'};
else
    customParamOrder = {'n','A','B'};
end
numParams = length(paramNames);
f = figure('color','w','Renderer','painters');
paramMeanValues = zeros(numParams,numTimePoints);
for i = 1:numParams
    if doLogLambda
        if i >= 2
            p = i+1;
        else
            p = i;
        end
        subplot(1,numParams+1,p)
    else
        p = i;
        subplot(1,numParams,p)
    end
    hold('on')
    axis('square')

    ind = find(strcmp(customParamOrder{p},paramNames));

    % Get mean parameter estimate:
    paramEstMean = cellfun(@(x)x.(paramNames{ind}),fittedParams);
    if strcmp(paramNames{ind},'n')
        paramEstMean = 1./paramEstMean;
    end

    % Fit linear regression:
    if strcmp(paramNames{ind},'n')
        ft = fittype('c*x');
        [c,Stats] = fit(maxDistances,paramEstMean,ft);
        f_handle = @(x) c.c*x;
    else
        [c,Stats] = fit(maxDistances,paramEstMean,'poly1');
        Gradient = c.p1; Intercept = c.p2;
        f_handle = @(x) Gradient*x + Intercept;
    end
    xRange = linspace(0,maxDistances(end));
    plot(xRange,f_handle(xRange),':k')
    ylabel(paramNames{ind})
    xlabel('Brain size, d_{max} (mm)')

    % Get error bounds:
    errs = cellfun(@(x)diff(x(:,ind))/2,CIs);

    % Color by time point:
    for t = 1:numTimePoints
        errorbar(maxDistances(t),paramEstMean(t),errs(t),'-o','MarkerSize',8,...
                        'Color',params.colors(t,:),'LineWidth',2)
    end
    % Store for output:
    paramMeanValues(i,:) = paramEstMean;
    paramErrValues(i,:) = errs;
end
f.Position = [807         771        1024         286];
save('parameterFits.mat','paramMeanValues','paramErrValues');


if doLogLambda
    subplot(1,numParams+1,2)
    decayConstant_voxel(params);
end

end
