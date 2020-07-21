function decayConstant_voxel(params,maxDistances,paramEstMean,errs,addHuman)

% if nargin < 1
%     params = GiveMeDefaultParams();
% end
if nargin < 5
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
    for t = 1:length(params.timePoints)
        loglog(maxDistances(t),paramEstMean(t),'o',...
                    'MarkerEdgeColor',brighten(params.colors(t,:),-0.5),...
                    'MarkerFaceColor',params.colors(t,:),'MarkerSize',7)
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
if addHuman
    xRange = logspace(min(log10(maxDistances)),log10(dMaxHuman),50);
else
    xRange = logspace(min(log10(maxDistances)),max(log10(maxDistances)),50);
end
plot(xRange,10.^c.p2*xRange.^c.p1,'--k');
% Gradient = c.p1; Intercept = c.p2;
str = sprintf('lambda = %g d^{%f}',10^c.p2,c.p1);
fprintf(1,'%s\n',str);
text(mean(maxDistances),mean(paramEstMean),str);

%-------------------------------------------------------------------------------
% Linear fit in linear-linear:
[f_handle,stats,c] = GiveMeFit(maxDistances,paramEstMean,'linear');
plot(xRange,c.p1 + xRange*c.p1,'-','color',ones(1,3)*0.5);

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
