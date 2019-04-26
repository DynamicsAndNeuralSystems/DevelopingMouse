whatNorm='scaledSigmoid';
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
incrementVector=1000:1000:2000; %1000:1000:5000; % number of data incremented in steps of 1000 from 1000 to 5000
samplingNum=5;%100;
variance=cell(length(timePoints),1);
decayConstant_samples=cell(length(incrementVector),1);

for k=1:length(incrementVector) % for each sampling size
  for j=1:samplingNum % collect decay constants 100 times
    distances_all = cell(length(timePoints),1);
    corrCoeff_all = cell(length(timePoints),1);
    % create gene expression matrix
    [voxGeneMat_all,...
    distMat_all,...
    dataIndSelect_all]=makeGeneExpressionMatrix(whatNorm, incrementVector(k));
    % compute correlation
    for i=1:length(timePoints)
      [distances_all{i},corrCoeff_all{i}]=computeCorrCoeff_distances(voxGeneMat_all{i},...
                                                                      distMat_all{i},...
                                                                      dataIndSelect_all{i});
    end
    % fit and obtain correlation coefficient (all time points included)
    decayConstant_samples{k}=zeros(samplingNum,1);
    [~, decayConstant_samples{k}(j), ~]=getFitting(dataType,distances_all,corrCoeff_all);
  end
end
% calculate variance for each time point
for i=1:length(timePoints)
  variance{i}=zeros(length(incrementVector),1);
  for k=1:length(incrementVector)
    variance{i}(k)=var(decayConstant_samples{k});
  end
end

% plot variance against sampling size
for i=1:length(timePoints)
  f=figure('color','w','Position',get(0, 'Screensize'));
  plot(incrementVector,variance{i})
  xLabel('Sample size','FontSize',16)
  ylabel('Variance in decay constant','FontSize',13)
  str=sprintf('Variance in decay constant against sample size, %s',timePoints{i});
  title(str,'FontSize',19)
  F=getframe(f);
  filename=strcat(sprintf('decay_constant_variance_%s',timePoints{i}),'.jpeg');
  str=fullfile('Outs','decay_constant_variance',filename);
  imwrite(F.cdata,str,'jpeg');
end

% while (numData(1)<5031 | numData(2)<9471 | numData(3)<11314 | numData(4)<11288 | numData(5)<19754 | numData(6)<21557 | numData(7)<24826)

% increase numData by 1000 if not reach max

% for each number of data sample

% increment number of data sample by 1000
% if one time point reaches the max data sample (5031,9471,11314,11288,19754,21557,24826), only increment the other time timePoints
% until all good voxels are used
