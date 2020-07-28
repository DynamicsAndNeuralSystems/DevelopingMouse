function WithinBetween(params,doSubsample,allInOne,doSave)
% Compare CGE curves within/between major brain divisions
% (hindbrain/midbrain/forebrain)
%-------------------------------------------------------------------------------
if nargin < 1 || isempty(params)
    params = GiveMeDefaultParams();
end
if nargin < 2
    % This is a different subsampling?
    doSubsample = true;
end
if nargin < 3
    allInOne = true;
end
if nargin < 4
    doSave = true;
end

% Sample 1000 voxels from each of the three major anatomical subdivisions (fmh):
params.thisBrainDiv = 'fmhSample';
params.doSubsample = false;
doUnified = false;

%-------------------------------------------------------------------------------
% Load the distance, CGE data:
if allInOne
    f = figure('color','w');
    f.Position(3:4) = [481,759];
end
numTimePoints = length(params.timePoints);
for i = 1:numTimePoints
    % Extract the d-CGE curve:
    [dist,CGE,voxInfo,geneInfo] = ComputeDistanceCGE(params,params.timePoints{i},false);

    % Now we want different subsets:
    numVoxels = height(voxInfo);
    if doSubsample
        isFF = MakeMeMask(numVoxels,voxInfo.sampleForebrain,voxInfo.sampleForebrain);
        isMM = MakeMeMask(numVoxels,voxInfo.sampleMidbrain,voxInfo.sampleMidbrain);
        isHH = MakeMeMask(numVoxels,voxInfo.sampleHindbrain,voxInfo.sampleHindbrain);
        isFH = MakeMeMask(numVoxels,voxInfo.sampleForebrain,voxInfo.sampleHindbrain);
        isFM = MakeMeMask(numVoxels,voxInfo.sampleForebrain,voxInfo.sampleMidbrain);
        isMH = MakeMeMask(numVoxels,voxInfo.sampleMidbrain,voxInfo.sampleHindbrain);
    else
        isFF = MakeMeMask(numVoxels,voxInfo.isForebrain,voxInfo.isForebrain);
        isMM = MakeMeMask(numVoxels,voxInfo.isMidbrain,voxInfo.isMidbrain);
        isHH = MakeMeMask(numVoxels,voxInfo.isHindbrain,voxInfo.isHindbrain);
        isFH = MakeMeMask(numVoxels,voxInfo.isForebrain,voxInfo.isHindbrain);
        isFM = MakeMeMask(numVoxels,voxInfo.isForebrain,voxInfo.isMidbrain);
        isMH = MakeMeMask(numVoxels,voxInfo.isMidbrain,voxInfo.isHindbrain);
    end

    % Get plottin'
    if ~allInOne
        f = figure('color','w');
        f.Position(3:4) = [852   328];
        subplot(1,2,1);
    else
        subplot(numTimePoints,2,(i-1)*2+1);
    end
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
    if ~allInOne || i==1
        legend([ph{:}],{'fh','fm','mh','ff','mm','hh'})
    end
    xlabel('Distance (mm)')
    ylabel('CGE')
    ax.XLim = [0,max(dist(:))];

    % Coarser:
    if ~allInOne
        subplot(1,2,2);
    else
        subplot(numTimePoints,2,(i-1)*2+2);
    end
    hold('on');
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
    ax.XLim = [0,max(dist(:))];
    ylabel('CGE')

    if ~allInOne & doSave
        fileName = fullfile('Outs',sprintf('CGE_within_between%s.svg',params.timePoints{i}));
        saveas(f,fileName,'svg')
        fprintf(1,'Saved figure to %s\n',fileName);
    end
end

%-------------------------------------------------------------------------------
if allInOne & doSave
    fileName = fullfile('Outs',sprintf('CGE_within_between_AllTime.svg'));
    saveas(f,fileName,'svg')
    fprintf(1,'Saved figure to %s\n',fileName);
end

end
