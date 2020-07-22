function WithinBetween(params)
% Compare CGE curves within/between major brain divisions
% (hindbrain/midbrain/forebrain)
%-------------------------------------------------------------------------------

if nargin < 1
    params = GiveMeDefaultParams();
end

params.thisBrainDiv = 'brain'; %'wholeBrain';
doUnified = false;

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
    f.Position(3:4) = [852   328];
    subplot(1,2,1);
    hold('on')
    title(params.timePoints{i})

    % Compute the distance-binning and plot:
    if doUnified
        % Use the same distance bins for every type
        all = (isFH|isFM|isMH|isFF|isMM|isHH);
        [xBinCentersU,xThresholdsU,yMeansU,yStdsU] = makeQuantiles(dist(all),CGE(all),...
                                                        params.numThresholds);
    end
    theFilters = {isFH,isFM,isMH,isFF,isMM,isHH};
    colors = [215,147,218;152,200,82;94,196,224;215,179,82;109,206,144;237,146,113]/255;
    ph = cell(length(theFilters),1);
    for j = 1:length(theFilters)
        if doUnified
            xData = dist(theFilters{j});
            yData = CGE(theFilters{j});
            yMeans = arrayfun(@(x)mean(yData(xData>=xThresholdsU(x) & xData < xThresholdsU(x+1))),1:params.numThresholds-1);
            yStds = arrayfun(@(x)std(yData(xData>=xThresholdsU(x) & xData < xThresholdsU(x+1))),1:params.numThresholds-1);
        else
            [xBinCenters,xThresholds,yMeans,yStds] = makeQuantiles(dist(theFilters{j}),...
                                CGE(theFilters{j}),params.numThresholds);
        end
        if j>3
            colorHere = brighten(colors(j,:),-0.8);
        else
            colorHere = brighten(colors(j,:),+0.3);
        end
        if doUnified
            ph{j} = PlotQuantiles(xThresholdsU,yMeans,yStds,colorHere,true);
        else
            ph{j} = PlotQuantiles(xThresholds,yMeans,yStds,colorHere,true);
        end

        if j<4
            ph{j}.LineStyle = '--';
        end
    end
    legend([ph{:}],{'fh','fm','mh','ff','mm','hh'})
    xlabel('Distance (mm)')
    ylabel('CGE')

    % Coarser:
    subplot(1,2,2); hold('on');
    title(params.timePoints{i})
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

    xlabel('Distance (mm)')
    ylabel('CGE')

    fileName = fullfile('Outs',sprintf('CGE_within_between%s.svg',params.timePoints{i}));
    saveas(f,fileName,'svg')
    fprintf(1,'Saved figure to %s\n',fileName);
end

%-------------------------------------------------------------------------------

end
