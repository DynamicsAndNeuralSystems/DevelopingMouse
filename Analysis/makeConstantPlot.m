function f = makeConstantPlot(params,doSave)
% Plot variation of fitted parameters over time
%-------------------------------------------------------------------------------

if nargin < 1 || isempty(params)
    params = GiveMeDefaultParams();
end
if nargin < 2
    doSave = true;
end

%-------------------------------------------------------------------------------
% Load in the fitted parameters (ComputeFittingResults)
%-------------------------------------------------------------------------------
[params,fittedParams,CIs,goodTimePoint] = LoadParameterFits(params);

%-------------------------------------------------------------------------------
goodTimeInd = find(goodTimePoint);
numTimePoints = length(goodTimeInd);
paramNames = coeffnames(fittedParams{goodTimeInd(1)});
fittedParams = fittedParams(goodTimePoint);

% Get max distances
maxDistances = makeMaxDistance(params);
maxDistances = maxDistances(goodTimePoint);

%-------------------------------------------------------------------------------
% Plotting
%-------------------------------------------------------------------------------
theParameter = {'n','n','n','A','B'};
customParamOrder = {'nLinear','nLog','nLogHuman','A','B'};
numParams = length(theParameter);

f = figure('color','w','Renderer','painters');
paramMeanValues = zeros(numParams,numTimePoints);
paramErrValues = zeros(numParams,numTimePoints);
for i = 1:numParams
    % Get mean parameter estimate:
    paramEstMean = cellfun(@(x)x.(theParameter{i}),fittedParams);
    if strcmp(theParameter{i},'n')
        paramEstMean = 1./paramEstMean;
    end

    paramInd = find(strcmp(paramNames,theParameter{i}));

    % Estimate error bounds:
    errs = cellfun(@(x) diff(x(:,paramInd))/2,CIs);

    % Store for output:
    paramMeanValues(i,:) = paramEstMean;
    paramErrValues(i,:) = errs;

    % Plot:
    % plotHere = find(strcmp(paramNames{i},plotOrder));
    % if isempty(plotHere)
    %     continue;
    % end
    subplot(1,numParams,i)
    if i==1
        title(sprintf('%s-%s',params.thisBrainDiv,params.thisCellType))
    end
    hold('on')
    axis('square')

    switch customParamOrder{i}
    case {'nLinear','A','B'}
        % Fit linear regression:
        xRange = linspace(0,maxDistances(end));
        if strcmp(theParameter{i},'n')
            ft = fittype('c*x');
            [c,Stats] = fit(maxDistances,paramEstMean,ft);
            f_handle = @(x) c.c*x;
            plot(xRange,f_handle(xRange),'--','color',ones(1,3)*0.5)
        else
            [c,Stats] = fit(maxDistances,paramEstMean,'poly1');
            Gradient = c.p1; Intercept = c.p2;
            f_handle = @(x) Gradient*x + Intercept;
            plot(xRange,f_handle(xRange),':k')
        end
        [r,pVal] = corr(maxDistances,paramEstMean);
        fprintf(1,'%s: r = %g, p = %g\n',theParameter{i},r,pVal);
        if strcmp(theParameter{i},'n')
            ylabel('Spatial correlation length, \lambda');
        else
            ylabel(theParameter{i})
        end
        xlabel('Brain size, d_{max} (mm)')
        % Color by time point:
        for t = 1:numTimePoints
            errorbar(maxDistances(t),paramEstMean(t),errs(t),'-o','MarkerSize',8,...
                            'Color',params.colors(goodTimeInd(t),:),'LineWidth',2)
        end
    case 'nLog'
        decayConstant_voxel(params,maxDistances,paramEstMean,errs,goodTimeInd,false);
        axis('square')
    case 'nLogHuman'
        decayConstant_voxel(params,maxDistances,paramEstMean,errs,goodTimeInd,true);
        axis('square')
    end
end
f.Position(3:4) = [1291,420];

%-------------------------------------------------------------------------------
if doSave
    % Save to file:
    fileName = fullfile('Outs','ParameterScaling.svg');
    saveas(f,fileName,'svg')
    fprintf(1,'Saved to %s\n',fileName);
end

end
