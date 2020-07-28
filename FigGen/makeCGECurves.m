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
% First part of Fig. 2
f = figure('color','w','Renderer','painters');
hold('on')
numTimePoints = length(params.timePoints);
for j = 1:numTimePoints
    fprintf(1,'%u/%u: %s\n',j,numTimePoints,params.timePoints{j});
    subplot(2,4,j)
    makeBinningPlot_withExponential(params,params.timePoints{j},false);
    ylabel('CGE')
    ylim([-0.1 0.8])
end
f.Position = [607   797   779   325];

% Save out:
if doSave
    fileName = fullfile('Outs',sprintf('All_CGE_curves_%s.svg',params.thisBrainDiv));
    saveas(f,fileName,'svg')
    fprintf(1,'Saved to %s\n',fileName);
end

%-------------------------------------------------------------------------------
% Second part of Fig. 2
% f = figure('color','w','Renderer','painters');
% subplot(2,1,1)
% params.scaledDistance = false;
% makeExponentialPlot(params)
% subplot(2,1,2)
% params.scaledDistance = true;
% makeExponentialPlot(params);
%
% f.Position = [1000        1003         292         335];
%
% % Save out:
% fileName = fullfile('Outs','figure2','figure2_part2.svg');
% saveas(f,fileName,'svg')
% fprintf(1,'Saved to %s\n',fileName);

end
