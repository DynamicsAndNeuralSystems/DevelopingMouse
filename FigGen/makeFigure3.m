function makeFigure3()

%-------------------------------------------------------------------------------
% Set/retrieve default parameters:
params = GiveMeDefaultParams();

%-------------------------------------------------------------------------------
% Plot:
f = figure('color','w');
hold('on')

for j = 1:length(params.constantTypes)
    subplot(1,3,j)
    makeConstantPlot(numData,numThresholds,thisBrainDiv,...
                  false,thisCellType,thisDirection,false,...
                  constantTypes{j},false,true,false,false,false);
end
% f.Position = [0.1300    0.1100    0.3347    0.3412];
str = fullfile('Outs','figure3','figure3.svg');
saveas(f,str)

end
