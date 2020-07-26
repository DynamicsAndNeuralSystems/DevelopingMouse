function VisualizeSpatialExpression(timePointNow,params,colorHow,customSample,numPCs)

if nargin < 1
    timePointNow = 'E11pt5';
end
if nargin < 2 || isempty(params)
    params = GiveMeDefaultParams();
end
if nargin < 3
    colorHow = 'turboOne'; %'separate'; % 'turboOne'
end
if nargin < 4
    customSample = [];
end
if nargin < 5
    numPCs = 2;
end
%-------------------------------------------------------------------------------

params.thisBrainDiv = 'brain';
params.doSubsample = false;

% Be more stringent on missing data for the purposes of this visualization:
params.whatVoxelThreshold = 0.1;
params.whatGeneThreshold = 0.05;
[voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);
% Rescale to real space:
resolutionGrid = GiveMeParameter('resolutionGrid');
coOrds = coOrds*resolutionGrid.(timePointNow);
numVoxels = height(voxInfo);

makeSample = @(xInd) xInd(randsample(length(xInd),min(length(xInd),procParams.numData)));
if ~isempty(customSample) && (numVoxels > customSample)
    keepVoxel = randsample(numVoxels,customSample);
    fprintf(1,'Subsampling down to %u -> %u random voxels for visualization\n',numVoxels,customSample);
    voxelGeneExpression = voxelGeneExpression(keepVoxel,:);
    voxInfo = voxInfo(keepVoxel,:);
    coOrds = coOrds(keepVoxel,:);
    numVoxels = height(voxInfo);
end

zScoredExpression = BF_NormalizeMatrix(voxelGeneExpression,'zscore');

% Compute PCA of expression:
fprintf(1,'Computing PCA of gene-expression maps...\n');
[pcCoeff,Y,~,~,percVar] = pca(zScoredExpression,'algorithm','als','NumComponents',numPCs);

% [pcCoeff,Y,~,~,percVar] = pca(zScoredExpression,'Rows','pairwise','NumComponents',2);
%
% if ~any(isnan(voxelGeneExpression))
%     [pcCoeff,Y,~,~,percVar] = pca(zscore(voxelGeneExpression),'NumComponents',2);
% else
%     warning(sprintf(['Data matrix contains %.2g%% NaNs. Estimating covariances on remaining data...\n' ...
%         '(Could take some time...)'],100*mean(isnan(voxelGeneExpression(:)))))
%     % Data matrix contains NaNs; try the pairwise rows approximation to the
%     % covariance matrix:
%     [pcCoeff,Y,~,~,percVar] = pca(BF_NormalizeMatrix(voxelGeneExpression,'zscore'),...
%                             'Rows','pairwise','NumComponents',2);
%     % If this fails (covariance matrix not positive definite), can try the
%     % (...,'algorithm','als') option in pca... (or toolbox for probabilistic PCA)
% end

%-------------------------------------------------------------------------------
% markerSize = zeros(length(coOrds),1);
% markerSize(voxInfo.isForebrain)=30;
% markerSize(voxInfo.isMidbrain)=20;
% markerSize(voxInfo.isHindbrain)=10;

%-------------------------------------------------------------------------------
switch colorHow
case 'separate'
    % Normalize seperately:
    almostOne = 1-1e-5;
    YNorm = almostOne*BF_NormalizeMatrix(Y,'scaledSigmoid');
    YNorm(voxInfo.isMidbrain,:) = 1 + YNorm(voxInfo.isMidbrain,:);
    YNorm(voxInfo.isHindbrain,:) = 2 + YNorm(voxInfo.isHindbrain,:);
case 'turboOne'
    YNorm = Y;
end

%-------------------------------------------------------------------------------
markerSize = 60;
markerAlpha = 0.7;
f = figure('color','w');
ax = cell(numPCs,1);
for i = 1:numPCs
    ax{i} = subplot(1,numPCs,i);
    % Redefine map to conventional coordinates:
    myX = coOrds(:,1); % anterior–posterior
    myY = coOrds(:,3); % left-right
    myZ = -coOrds(:,2); % inferior–superior
    scatter3(coOrds(:,1),coOrds(:,2),coOrds(:,3),markerSize,YNorm(:,i),'filled',...
                    'MarkerFaceAlpha',markerAlpha)

    xlabel('anterior-posterior (mm)')
    ylabel('left-right (mm)')
    zlabel('inferior-superior (mm)')
    axis('equal') % make it better represent real space

    title(sprintf('%s: gene expression PC%u',timePointNow,i))

    % Add colorbar:
    cB = colorbar();
    switch colorHow
    case 'separate'
        cB.Ticks = [0.5,1.5,2.5];
        cB.TickLabels = {'forebrain','midbrain','hindbrain'};
    case 'turboOne'
        %
    end
    cB.Location = 'southoutside';
end

switch colorHow
case 'separate'
    colormap([BF_getcmap('oranges',9,0);BF_getcmap('purples',9,0);BF_getcmap('reds',9,0)])
    caxis([0,3])
case 'turboOne'
    colormap(flipud(BF_getcmap('redyellowblue',11,0)))
    % giveMeTurboMap()
end
f.Position(3:4) = [1303,528];



if numPCs > 1
    Link = linkprop([ax{:}],{'CameraUpVector', 'CameraPosition', ...
        'CameraTarget', 'XLim', 'YLim', 'ZLim'});
    setappdata(f, 'StoreTheLink', Link);
end

end
