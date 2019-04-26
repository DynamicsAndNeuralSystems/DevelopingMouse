whatNorm='scaledSigmoid';
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
incrementVector=1000:1000:5000; % number of data incremented in steps of 1000 from 1000 to 5000
variance=zeros(length(incrementVector),1);
decay_constant=zeros(length(incrementVector),1);
% calculate separately for each time point

for k=incrementVector
  % create gene expression matrix
  [voxGeneMat_all,distMat_all,dataIndSelect_all]=makeGeneExpressionMatrix(whatNorm, k);
  for i=1:length(timePoints)
    % compute correlation
    [distances,corrCoeff]=computeCorrCoeff_distances(voxGeneMat_all{i},...
                                                    distMat_all{i},...
                                                    dataIndSelect_all{i});
    % fitting
    
    % obtain correlation coefficient
  end
end
% while (numData(1)<5031 | numData(2)<9471 | numData(3)<11314 | numData(4)<11288 | numData(5)<19754 | numData(6)<21557 | numData(7)<24826)

  % increase numData by 1000 if not reach max

% for each number of data sample
% collect decay constants 100 times and compute variance
% increment number of data sample by 1000
% if one time point reaches the max data sample (5031,9471,11314,11288,19754,21557,24826), only increment the other time timePoints
% until all good voxels are used
