function plotFitting_singleTimePoint(xData,params,fit_funHandle,xDataDensity,theColor,makeNewFigure)
% thisDataType: 'voxel' or 'structure'
% F is the getframe object for setting figure saving size
% xDataDensity: >0 and <=1; indicates the proportion of xData to use in plotting

if makeNewFigure
    f = figure('color','w'); % create new figure
end

% Resample x-axis across numXSamples:
numXSamples = 100;
xDataResample = linspace(min(xData),max(xData),numXSamples);

% Plot:
plot(xDataResample,fit_funHandle(xDataResample),'-','Color',theColor,'MarkerEdgeColor',theColor,'LineWidth',2);

end
