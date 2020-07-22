function PredictHuman()
% Results for predicting human gene-expression variation from

whatFit = 'scaling';
whatBrainDivisions = {'forebrain','midbrain','hindbrain','brain','Dpall'};

dMaxHuman = 148;
lambdaHuman = 61.4;

numDivisions = length(whatBrainDivisions);

%-------------------------------------------------------------------------------
% Load data
[params,fittedParams,CIs] = LoadParameterFits(params);

%-------------------------------------------------------------------------------

% Linear fit in log-log:
[f_handle,stats,c] = GiveMeFit(log10(maxDistances),log10(paramEstMean),'linear');
numIncrements = 50;
if addHuman
    xRange = logspace(min(log10(maxDistances)),log10(dMaxHuman),numIncrements);
else
    xRange = logspace(min(log10(maxDistances)),max(log10(maxDistances)),numIncrements);
end
f_handle = @(x) 10.^c.p2*x.^c.p1;
plot(xRange,f_handle(xRange),'--k');
% Gradient = c.p1; Intercept = c.p2;
str = sprintf('lambda = %g d^{%f}',10^c.p2,c.p1);
fprintf(1,'%s\n',str);
text(mean(maxDistances),mean(paramEstMean),str);

if addHuman
    fprintf(1,'Mouse developmental prediction of human lambda (scaling): %.3g (measured = %.3g)\n',...
                    f_handle(dMaxHuman),lambdaHuman);
end

%-------------------------------------------------------------------------------
% Proportional fit (in linear-linear):
ft = fittype('c*x');
[c,Stats] = fit(maxDistances,paramEstMean,ft);
f_handle = @(x) c.c*x;
plot(xRange,f_handle(xRange),'-','color',ones(1,3)*0.5);

ci = predint(fitresult,x)


end
