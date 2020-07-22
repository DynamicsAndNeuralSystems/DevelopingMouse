function WithinBetween(params)

if nargin < 1
    params = GiveMeDefaultParams();
end

params.thisBrainDiv = 'brain'; %'wholeBrain';
params.numThresholds = 11;


%-------------------------------------------------------------------------------
% Load the distance, CGE data:
numTimePoints = length(params.timePoints);
for i = 1:numTimePoints
    % Extract the d-CGE curve:
    [dist,CGE,voxInfo,geneInfo] = ComputeDistanceCGE(params,params.timePoints{i},false);

    % Now we want different subsets:
    numVoxels = height(voxInfo);
    isFF = MakeMeMask(numVoxels,voxInfo.isForebrain,voxInfo.isForebrain);
    isMM = MakeMeMask(numVoxels,voxInfo.isMidbrain,voxInfo.isMidbrain);
    isHH = MakeMeMask(numVoxels,voxInfo.isHindbrain,voxInfo.isHindbrain);
    isFH = MakeMeMask(numVoxels,voxInfo.isForebrain,voxInfo.isHindbrain);
    isFM = MakeMeMask(numVoxels,voxInfo.isForebrain,voxInfo.isMidbrain);
    isMH = MakeMeMask(numVoxels,voxInfo.isMidbrain,voxInfo.isHindbrain);

    % Get plottin'
    f = figure('color','w');
    subplot(1,2,1); hold('on')
    title(params.timePoints{i})

    % Compute the distance-binning and plot:
    theFilters = {isFF,isMM,isHH,isFH,isFM,isMH};
    colors = [215,147,218;152,200,82;94,196,224;215,179,82;109,206,144;237,146,113]/255;
    ph = cell(length(theFilters),1);
    for j = 1:length(theFilters)
        [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist(theFilters{j}),...
                                CGE(theFilters{j}),params.numThresholds);
        if j<4
            colorHere = brighten(colors(j,:),-0.5);
        else
            colorHere = brighten(colors(j,:),+0.5);
        end
        ph{j} = PlotQuantiles(xThresholds,yMeans,yStds,colors(j,:),true);
    end
    legend([ph{:}],{'ff','mm','hh','fh','fm','mh'})
    xlabel('Distance (mm)')
    ylabel('CGE')

    % Coarser:
    subplot(1,2,2); hold('on');
    isWithin = (isFF | isMM | isHH);
    isBetween = (isFH | isFM | isMH);
    theFilters = {isWithin,isBetween};
    ph_coarse = cell(length(theFilters),1);
    colors = [215,147,218;152,200,82]/255;
    for j = 1:length(theFilters)
        [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist(theFilters{j}),...
                        CGE(theFilters{j}),params.numThresholds);
        ph_coarse{j} = PlotQuantiles(xThresholds,yMeans,yStds,colors(j,:),true);
    end
    legend([ph_coarse{:}],{'within','between'})
end

%-------------------------------------------------------------------------------

end
