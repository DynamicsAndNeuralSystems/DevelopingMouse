function VisualizeSpatialExpression(timePointNow,params)

if nargin < 1
    timePointNow = 'E11pt5';
end
if nargin < 2
    params = GiveMeDefaultParams();
end
%-------------------------------------------------------------------------------

params.thisBrainDiv = 'brain';
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
markerSize = zeros(length(coOrds),1);
markerSize(voxInfo.isForebrain)=30;
markerSize(voxInfo.isMidbrain)=20;
markerSize(voxInfo.isHindbrain)=10;

f = figure('color','w');
for i = 1:2
    subplot(1,2,i)
    title(sprintf('Gene expression: PC%u',i))
    scatter3(coOrds(:,1),coOrds(:,2),coOrds(:,3),markerSize,Y(:,i),'filled')
    xlabel('x')
    ylabel('y')
    zlabel('z')
end
giveMeTurboMap()
colorbar()

end
