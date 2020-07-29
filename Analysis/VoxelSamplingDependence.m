% VoxelSamplingDependence

maxVoxels = 100:100:1000;
numVoxelSamples = length(maxVoxels);

params = GiveMeDefaultParams();
numTimePoints = length(params.timePoints);

lambdaEst = nan(numTimePoints,numVoxelSamples);
for v = 1:numVoxelSamples
    params.maxVoxels = maxVoxels(v);
    for i = 1:numTimePoints
        [dist,CGE] = ComputeDistanceCGE(params,params.timePoints{i},true);
        % Bin the data:
        [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist,CGE,params.numThresholds);
        % Fit the binned data (on means):
        [fitHandle,stats,fittedParams] = GiveMeFit(xBinCenters,yMeans,params.whatFit,true);
        lambdaEst(i,v) = 1/fittedParams.n;
    end
end

%-------------------------------------------------------------------------------
f = figure('color','w');
hold('on')
for j = 1:numTimePoints
    plot(maxVoxels,lambdaEst(j,:),'o-','Color',params.colors(j,:),...
                'MarkerEdgeColor',params.colors(j,:),'LineWidth',1);
end
xlabel('Number of voxels in sample')
ylabel('lambda estimate')
f.Position(3:4) = [388   320];

%-------------------------------------------------------------------------------
% Save out:
fileName = fullfile('Outs','voxelSampling.svg');
saveas(f,fileName,'svg')
fprintf(1,'Saved to %s\n',fileName);
