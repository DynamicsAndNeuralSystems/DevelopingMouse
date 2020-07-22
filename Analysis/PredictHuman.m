function PredictHuman()
% Results for predicting human gene-expression variation from

whatFit = 'scaling'; % 'propLinear', ...
whatBrainDivisions = {'forebrain','midbrain','hindbrain','brain','Dpall'};

dMaxHuman = 148;
lambdaHuman = 61.4;

numDivisions = length(whatBrainDivisions);
maxDistances = makeMaxDistance(params);

for b = 1:numDivisions
    params.thisBrainDiv = whatBrainDivisions{b};
    fprintf(1,'[[%u/%u]] %s\n',b,numDivisions,params.thisBrainDiv);

    %-------------------------------------------------------------------------------
    % Load data
    [params,fittedParams,CIs,goodTimePoint] = LoadParameterFits(params);
    maxDistancesB = maxDistances(goodTimePoint);

    switch whatFit
    case 'scaling'
        %-------------------------------------------------------------------------------
        % Linear fit in log-log:
        [f_handle,stats,fitInfo] = GiveMeFit(log10(maxDistancesB),log10(paramEstMean),'linear');
        f_handle = @(x) 10.^fitInfo.p2*x.^fitInfo.p1;
        fprintf(1,'lambda = %g d^{%f}\n',10^fitInfo.p2,fitInfo.p1);
    case 'propLinear'
        %-------------------------------------------------------------------------------
        % Proportional fit (in linear-linear):
        ft = fittype('c*x');
        [fitInfo,stats] = fit(maxDistancesB,paramEstMean,ft);
        f_handle = @(x) fitInfo.c*x;
        fprintf(1,'lambda = %g d\n',fitInfo.c);
    end

    fprintf(1,'Mouse developmental prediction (%s) of human lambda (scaling): %.3g (measured = %.3g)\n',...
                    params.thisBrainDiv,f_handle(dMaxHuman),lambdaHuman);

    ci = predint(fitInfo,dMaxHuman,0.95);
    fprintf(1,'CI = %.3g,%.3g\n',ci(1),ci(2));

end


end
