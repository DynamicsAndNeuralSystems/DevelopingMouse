function makeFigure3()

%-------------------------------------------------------------------------------
% Set/retrieve default parameters:
params = GiveMeDefaultParams();

%-------------------------------------------------------------------------------
% Plot fitted model parameters across time:
f = makeConstantPlot(params);

% Save to file:
fileName = fullfile('Outs','figure3','figure3.svg');
saveas(f,fileName,'svg')
fprintf(1,'Saved to %s\n',fileName);

end
