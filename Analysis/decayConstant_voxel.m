function decayConstant_voxel(params,maxDistances,paramEstMean,errs,goodTimeInd,addHuman)

% if nargin < 1
%     params = GiveMeDefaultParams();
% end
if nargin < 6
    addHuman = false;
end

%-------------------------------------------------------------------------------
% Load in what we need:
% maxDistances = makeMaxDistance(params);
% load('parameterFits.mat','paramMeanValues','paramErrValues');
% paramEstMean = paramEstMean(1,:);
%-------------------------------------------------------------------------------
doColorful = true;
% addHuman = false;

% f = figure('color','w');
hold('on');
grid('on');
if doColorful
    for t = 1:length(goodTimeInd)
        loglog(maxDistances(t),paramEstMean(t),'o',...
                    'MarkerEdgeColor',brighten(params.colors(goodTimeInd(t),:),-0.5),...
                    'MarkerFaceColor',params.colors(goodTimeInd(t),:),'MarkerSize',7)
    end
    if addHuman
        dMaxHuman = 148;
        lambdaHuman = 61.4;
        humanColor = ones(3,1)*0.5;
        loglog(dMaxHuman,lambdaHuman,'o',...
                    'MarkerEdgeColor',brighten(humanColor,-0.5),...
                    'MarkerFaceColor',humanColor,'MarkerSize',7)
    end
else
    loglog(maxDistances,paramEstMean,'ok')
end

ax = gca();
ax.XScale = 'log';
ax.YScale = 'log';
axis('square')
xlabel('Brain size, d_{max}');
ylabel('Spatial correlation length, \lambda');
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

if addHuman
    fprintf(1,'Mouse developmental prediction of human lambda (linear): %.3g (measured = %.3g)\n',...
                    f_handle(dMaxHuman),lambdaHuman);
end

%-------------------------------------------------------------------------------
% ADD HUMAN?
%-------------------------------------------------------------------------------

%
% legend('show')
% str=sprintf('Developing Mouse decay constant against max distance, %s', 'wholeBrain');
% title(str,'Fontsize',16)
%
% % save figure
% filename=strcat('decayConstant_log','.jpeg');
% str=fullfile('Outs','decay_constant_log',filename);
% saveas(f,str)

end
