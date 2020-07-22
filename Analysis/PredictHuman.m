function PredictHuman(params)
% Results for predicting human gene-expression variation from

if nargin < 1
    params = GiveMeDefaultParams();
end

whatFits = {'scaling','propLinear'}; %'scaling'; % 'propLinear', ...
whatBrainDivisions = {'brain','Dpall','forebrain','midbrain','hindbrain',};

dMaxHuman = 148;
lambdaHuman = 61.4;

numDivisions = length(whatBrainDivisions);
maxDistances = makeMaxDistance(params);
cis = cell(numDivisions,2);
thePred = zeros(numDivisions,2);
numGood = zeros(numDivisions,1);
for b = 1:numDivisions
    params.thisBrainDiv = whatBrainDivisions{b};
    fprintf(1,'[[%u/%u]] %s\n',b,numDivisions,params.thisBrainDiv);

    %-------------------------------------------------------------------------------
    % Load data
    [params,fittedParams,CIs,goodTimePoint] = LoadParameterFits(params);
    maxDistancesB = maxDistances(goodTimePoint);
    fittedParams = fittedParams(goodTimePoint);
    paramEstMean = cellfun(@(x)1/x.n,fittedParams);
    numGood(b) = sum(goodTimePoint);

    for f = 1:2
        whatFit = whatFits{f};
        switch whatFit
        case 'scaling'
            %-------------------------------------------------------------------------------
            % Linear fit in log-log:
            [f_handle,stats,fitInfo] = GiveMeFit(log10(maxDistancesB),log10(paramEstMean),'linear');
            cis{b,f} = 10.^predint(fitInfo,log10(dMaxHuman),0.95);
            f_handle = @(x) 10.^fitInfo.p2*x.^fitInfo.p1;
            fprintf(1,'lambda = %g d^{%f}\n',10^fitInfo.p2,fitInfo.p1);
        case 'propLinear'
            %-------------------------------------------------------------------------------
            % Proportional fit (in linear-linear):
            ft = fittype('c*x');
            [fitInfo,stats] = fit(maxDistancesB,paramEstMean,ft);
            cis{b,f} = predint(fitInfo,dMaxHuman,0.95);
            f_handle = @(x) fitInfo.c*x;
            fprintf(1,'lambda = %g d\n',fitInfo.c);
        end

        fprintf(1,'Mouse developmental prediction (%s) of human lambda (scaling): %.3g (measured = %.3g)\n',...
                        params.thisBrainDiv,f_handle(dMaxHuman),lambdaHuman);

        thePred(b,f) = f_handle(dMaxHuman);

        fprintf(1,'CI = [%.3g,%.3g]\n',cis{b,f}(1),cis{b,f}(2));
    end
end

%-------------------------------------------------------------------------------
f = figure('color','w');
f.Position(3:4) = [665   246];
ourColors = [82,190,152;208,84,61;110,198,84;180,135,52;198,201,76]/255;
ax = gca();
hold('on');
inc = [-0.05,0.05];
for f = 1:2
    for i = 1:numDivisions
        plot(ones(1,2)*i+inc(f),cis{i,f},'color',brighten(ourColors(f,:),0.8),'LineWidth',2)
    end
    plot((1:numDivisions)+inc(f),thePred(:,f),'o','MarkerFaceColor',ourColors(f,:),...
                                            'MarkerEdgeColor',ourColors(f,:));
end
plot([1,numDivisions],ones(1,2)*lambdaHuman,'--','color',ones(1,3)*0.4,'LineWidth',1.5)
ax.XTick = 1:numDivisions;
ax.XTickLabel = makeXTickLabel();
ax.YLim = [0,100];
xlabel('Brain division (fit)')
ylabel('\lambda_{human}^{(pred)}')

function theLabels = makeXTickLabel()
    theLabels = cell(numDivisions,1);
    for i = 1:numDivisions
        theLabels{i} = sprintf('%s (%u)',whatBrainDivisions{i},numGood(i));
    end
end

end
