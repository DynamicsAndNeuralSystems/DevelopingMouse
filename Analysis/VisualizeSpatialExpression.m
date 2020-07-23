function VisualizeSpatialExpression(timePointNow,params,colorHow)

if nargin < 1
    timePointNow = 'E11pt5';
end
if nargin < 2 || isempty(params)
    params = GiveMeDefaultParams();
end
if nargin < 3
    colorHow = 'turboOne'; %'separate'; % 'turboOne'
end
%-------------------------------------------------------------------------------

params.thisBrainDiv = 'brain';

% Be more stringent on missing data:
params.whatVoxelThreshold = 0.1;
params.whatGeneThreshold = 0.05;
[voxelGeneExpression,coOrds,voxInfo,geneInfo] = LoadSubset(params,timePointNow);

zScoredExpression = BF_NormalizeMatrix(voxelGeneExpression,'zscore');

% Compute PCA of expression:
[pcCoeff,Y,~,~,percVar] = pca(zScoredExpression,'algorithm','als','NumComponents',2);

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
    YNorm = Y;
    almostOne = 1-1e-5;
    YNorm(voxInfo.isForebrain,:) = almostOne*BF_NormalizeMatrix(Y(voxInfo.isForebrain,:),'scaledSigmoid');
    YNorm(voxInfo.isMidbrain,:) = 1 + almostOne*BF_NormalizeMatrix(Y(voxInfo.isMidbrain,:),'scaledSigmoid');
    YNorm(voxInfo.isHindbrain,:) = 2 + almostOne*BF_NormalizeMatrix(Y(voxInfo.isHindbrain,:),'scaledSigmoid');
case 'turboOne'
    YNorm = Y;
end

markerSize = 80;
f = figure('color','w');
for i = 1:2
    subplot(1,2,i)
    scatter3(coOrds(:,1),coOrds(:,2),coOrds(:,3),markerSize,YNorm(:,i),'filled','MarkerFaceAlpha',0.8)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    title(sprintf('%s: gene expression PC%u',timePointNow,i))
    % Add colorbar:
    cB = colorbar();
    switch colorHow
    case 'separate'
        cB.Ticks = [0.5,1.5,2.5];
        cB.TickLabels = {'forebrain','midbrain','hindbrain'};
    case 'turboOne'
    end
    cB.Location = 'southoutside';
end
switch colorHow
case 'separate'
    colormap([BF_getcmap('oranges',9,0);BF_getcmap('purples',9,0);BF_getcmap('reds',9,0)])
    caxis([0,3])
case 'turboOne'
    giveMeTurboMap()
end
f.Position(3:4) = [1303,528];


end
