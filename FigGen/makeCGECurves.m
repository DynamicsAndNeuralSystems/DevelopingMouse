function makeCGECurves(params,doSave)
% Make a CGE(d) curve for each developmental time point
%-------------------------------------------------------------------------------

% Set defaults:
if nargin < 1
    params = GiveMeDefaultParams();
end
if nargin < 2
    doSave = true;
end

%-------------------------------------------------------------------------------
f = figure('color','w','Renderer','painters');
hold('on')
numTimePoints = length(params.timePoints);
fitHandles = cell(numTimePoints,1);
maxDist = zeros(numTimePoints,1);
for j = 1:numTimePoints
    fprintf(1,'%u/%u: %s\n',j,numTimePoints,params.timePoints{j});
    subplot(2,4,j)
    [fitHandles{j},maxDist(j)] = makeBinningPlot_withExponential(params,params.timePoints{j},false);
    ylabel('CGE')
    ylim([-0.1 0.8])
end
f.Position = [607   797   779   325];

%-------------------------------------------------------------------------------
% Save out:
if doSave
    fileName = fullfile('Outs',sprintf('All_CGE_curves_%s_%s.svg',...
                params.thisBrainDiv,params.thisCellType));
    saveas(f,fileName,'svg')
    fprintf(1,'Saved to %s\n',fileName);
end

%-------------------------------------------------------------------------------
% Collapsed data:
f = figure('color','w','Renderer','painters');
% Plot it:
for b = 1:2
    subplot(2,1,b);
    hold('on')
    for j = 1:numTimePoints
        xRange = linspace(0,maxDist(j),100);
        if b==1
            xRangeScaled = xRange;
        else
            xRangeScaled = xRange/maxDist(j);
        end
        plot(xRangeScaled,fitHandles{j}(xRange),'-','Color',params.colors(j,:),...
                        'MarkerEdgeColor',params.colors(j,:),'LineWidth',1.5);
    end
    ylabel('CGE')
    if b==1
        xlabel('Distance, d (mm)')
    else
        xlabel('Relative distance, d/d_{max} (mm)')
    end
end
f.Position = [768   422   342   371];

% Save out:
fileName = fullfile('Outs','scalingTogether.svg');
saveas(f,fileName,'svg')
fprintf(1,'Saved to %s\n',fileName);

end
