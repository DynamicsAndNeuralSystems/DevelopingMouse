function decayConstant_voxel(params)

if nargin < 1
    params = GiveMeDefaultParams();
end

%-------------------------------------------------------------------------------
% Load in what we need:
maxDistances = makeMaxDistance(params);
load('parameterFits.mat','paramMeanValues','paramErrValues');
corrLengths = paramMeanValues(1,:);
%-------------------------------------------------------------------------------
doColorful = true;

% f = figure('color','w');
hold('on'); grid('on');
if doColorful
    for t = 1:length(params.timePoints)
        loglog(maxDistances(t),corrLengths(t),'o',...
                    'MarkerEdgeColor',brighten(params.colors(t,:),-0.5),...
                    'MarkerFaceColor',params.colors(t,:),'MarkerSize',7)
    end
else
    loglog(maxDistances,corrLengths,'ok')
end

ax = gca();
ax.XScale = 'log';
ax.YScale = 'log';
axis('square')
xlabel('Brain size, d_{max}');
ylabel('Spatial correlation length, \lambda');
[f_handle,stats,c] = GiveMeFit(log10(maxDistances),log10(corrLengths'),'linear');
xRange = logspace(min(log10(maxDistances)),max(log10(maxDistances)),50);
plot(xRange,10.^c.p2*xRange.^c.p1,'--k');
% Gradient = c.p1; Intercept = c.p2;
str = sprintf('lambda = %g d^{%f}',10^c.p2,c.p1);
fprintf(1,'%s\n',str);
text(mean(maxDistances),mean(corrLengths),str);

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
