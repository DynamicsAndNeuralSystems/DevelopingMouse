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
% ***Convert n -> inverses (hopefully valid to do nonlinear transformations of CIs)***
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
customParamOrder = {'n','A','B'};
numParams = length(paramNames);

plotOrder = {'nLog','nLogHuman','A','B'};
f = figure('color','w','Renderer','painters');
paramMeanValues = zeros(numParams,numTimePoints);
for i = 1:numParams
    ind = find(strcmp(customParamOrder{i},paramNames));

    % Get mean parameter estimate:
    paramEstMean = cellfun(@(x)x.(paramNames{ind}),fittedParams);
    if strcmp(paramNames{ind},'n')
        paramEstMean = 1./paramEstMean;
    end
    % Get error bounds:
    errs = cellfun(@(x)diff(x(:,ind))/2,CIs);

    % Store for output:
    paramMeanValues(i,:) = paramEstMean;
    paramErrValues(i,:) = errs;

    % Plot:
    plotHere = find(strcmp(paramNames{ind},plotOrder));
    if isempty(plotHere)
        continue;
    end
    subplot(1,length(plotOrder),plotHere)
    hold('on')
    axis('square')

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
    [r,pVal] = corr(maxDistances,paramEstMean);
    fprintf(1,'%s: r = %g, p = %g\n',paramNames{ind},r,pVal);
    xRange = linspace(0,maxDistances(end));
    plot(xRange,f_handle(xRange),':k')
    ylabel(paramNames{ind})
    xlabel('Brain size, d_{max} (mm)')

    % Color by time point:
    for t = 1:numTimePoints
        errorbar(maxDistances(t),paramEstMean(t),errs(t),'-o','MarkerSize',8,...
                        'Color',params.colors(t,:),'LineWidth',2)
    end
end
f.Position = [807         771        1024         286];
save('parameterFits.mat','paramMeanValues','paramErrValues');


% Add extras:
subplot(1,4,1)
decayConstant_voxel(params,false);
axis('square')
subplot(1,4,2)
decayConstant_voxel(params,true);
axis('square')


end
