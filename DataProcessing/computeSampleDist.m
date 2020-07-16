function computeSampleDist()
% Compute distance for a given samples
%-------------------------------------------------------------------------------

timePointIndex = find(strcmp(timePointNow,timePoints));
resolutionGrid = GiveMeParameter('resolutionGrid');
distMat = squareform(pdist(coOrds(dataIndSelect,:),...
                    'euclidean')*resolutionGrid.(timePoints{timePointIndex}));

% Extract the correlation coefficients (correlated gene expression, CGE)
geneCorr = corrcoef(voxGeneMat(dataIndSelect,:)','rows','pairwise');
corrCoeff = extractDistances(geneCorr);

% Extract distances from distance matrix
if procParams.scaledDistance
    distances = extractDistances(distMat)/getMaxDistance('wholeBrain',timePointNow);
else
    distances = extractDistances(distMat);
end

if procParams.withDirection
    % shuffle the distances and corrCoeff
    % shuffledOrder = randperm(length(distances));
    % distances = distances(shuffledOrder);
    % corrCoeff = corrCoeff(shuffledOrder);
    % determine directionality
    [angle_coronal,angle_axial,angle_sagittal,vecMat] = makeDirectionality(coOrds(dataIndSelect,:));
    % [angle_coronal,angle_axial,angle_sagittal]=makeDirectionality(coOrds(dataIndSelect,:),...
    %                                                               shuffledOrder);
    angle_coronal = extractDistances(squareform(angle_coronal));
    angle_axial = extractDistances(squareform(angle_axial));
    angle_sagittal = extractDistances(squareform(angle_sagittal));
else
    angle_coronal = NaN;
    angle_axial = NaN;
    angle_sagittal = NaN;
end

end
