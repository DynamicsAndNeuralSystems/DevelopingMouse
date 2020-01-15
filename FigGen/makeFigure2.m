function makeFigure2(numData,numThresholds)

% Set defaults:
params = GiveMeDefaultParams();

%-------------------------------------------------------------------------------
% First part of Fig. 2
f = figure('color','w');
hold('on')
numTimePoints = length(params.timePoints);
for j = 1:numTimePoints
    subplot(2,4,j)
    makeBinningPlot_withExponential(params,params.timePoints{j},false);
    ylim([-0.1 0.8])
end
f.Position = [607   737   892   385];

% Save out:
fileName = fullfile('Outs','figure2','figure2_part1.svg');
f.Renderer = 'painters';
saveas(f,fileName,'svg')
fprintf(1,'Saved to %s\n',fileName);

%-------------------------------------------------------------------------------
% Second part of Fig. 2
f = figure('color','w');
f.Renderer = 'painters';
subplot(1,2,1)
params.scaledDistance = false;
makeExponentialPlot(params,false)
subplot(1,2,2)
params.scaledDistance = true;
makeExponentialPlot(params,false);

% Save out:
fileName = fullfile('Outs','figure2','figure2_part2.svg');
saveas(f,fileName,'svg','Renderer','painters')
fprintf(1,'Saved to %s\n',fileName);

end
