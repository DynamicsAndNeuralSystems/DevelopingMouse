function makeFitting_voxelOnly(matFileName, isScaled, whatSubsetGene)
  % matFileName: a string of the matlab variable containing corrCoeffAll_distancesAll
  % isScaled: 1 means distances_all_scaled is used, 0 means distances_all is used
  % whatSubsetGene: a string indicating the name of the gene subset used; if not subset, set as "allGenes"
  % initialize
  spatialData=struct();
  fitting_stat_all=struct();
  decayConstant=struct();
  maxDistance=struct();
  % voxel data
  spatialData.voxel.corrCoeffAll=load('corrCoeffAll_distancesAll.mat','corrCoeff_all');
  spatialData.voxel.corrCoeffAll=spatialData.voxel.corrCoeffAll.('corrCoeff_all');
  if isScaled
    spatialData.voxel.distancesAll_scaled=load('corrCoeffAll_distancesAll.mat','distances_all_scaled');
    spatialData.voxel.distancesAll_scaled=spatialData.voxel.distancesAll_scaled.('distances_all_scaled');
    fieldname='distancesAll_scaled';
  else
    spatialData.voxel.distancesAll=load('corrCoeffAll_distancesAll.mat','distances_all');
    spatialData.voxel.distancesAll=spatialData.voxel.distancesAll.('distances_all');
    fieldname='distancesAll';
  end
  % Initialize
  dataType={'voxel'};
  for i=1:length(dataType)
      [f, F, fitting_stat_all.(dataType{i}), ...
      decayConstant.(dataType{i}), ...
      maxDistance.(dataType{i})]=getFitting(dataType{i},...
                                  spatialData.(dataType{i}).(fieldname),...
                                  spatialData.(dataType{i}).corrCoeffAll,...
                                  'wholeBrain',...
                                  'original');
      % save figure
      if isScaled
        str=fullfile('Outs', 'decay_constant_scaled',strcat('decayConstant_scaled',dataType{i},'_',whatSubsetGene,'.jpeg'));
      else
        str=fullfile('Outs', 'decay_constant',strcat('decayConstant',dataType{i},'_',whatSubsetGene,'.jpeg'));
      end
      imwrite(F.cdata,str,'jpeg');
  end

  %----------------------------------------------------------------------------------------------
  % save variables
  %----------------------------------------------------------------------------------------------
  if isScaled
    str=fullfile('Matlab_variables',strcat('fitting_scaled','_',whatSubsetGene,'.mat'));
  else
    str=fullfile('Matlab_variables',strcat('fitting','_',whatSubsetGene,'.mat'));
  end
  save(str, 'decayConstant', 'maxDistance','fitting_stat_all','spatialData')
end
% save

% fitting_stat_all = struct();
% % distances_all = cell(length(timePoints),1);
% % corrCoeff_all = cell(length(timePoints),1);
% % Get correlation coefficient and distances
% for i = 1:length(timePoints)
%     % extract the correlation coefficients
%     % geneCorr=corrcoef((voxGeneMat_all{i}(dataIndSelect_all{i},:))','rows','pairwise');
%     % corrCoeff_all{i}=geneCorr(find(triu(ones(size(geneCorr)),1)));
%     % % extract distances from distance matrix
%     % distances_all{i} = extractDistances(distMat_all{i});
%     % fit
%     [fitting_stat_all.(timePoints{i}).adjRSquare, fitting_stat_all.(timePoints{i}).fitObject,fitting_stat_all.(timePoints{i}).fHandle]=fitting_stat({'linear','exp_1_0','exp1','exp'}, '', distances_all{i}, corrCoeff_all{i});
% end
%
% %% exponential fit (3 parameter)
% decayConstant=zeros(length(timePoints),1);
% maxDistance = zeros(length(timePoints),1);
% % get the colours needed for plotting
% cmapOut = BF_getcmap('dark2',7,0,0);
% % Specify plotting style for later use
% theStyle = '-';
% theLineWidth = 2;
% % create the figure
% b=figure('color','w');
% for i=1:length(timePoints)
%     % collect decay constant
%     decayConstant(i)=fitting_stat_all.(timePoints{i}).fitObject.exp.n;
%     theColor=cmapOut(i,:);
%     % collect max distance
%     maxDistance(i)=max(distances_all{i});
%     % plot
%     plot(maxDistance(i),decayConstant(i),'-o','MarkerSize',10,'LineStyle',theStyle,...
%         'LineWidth',theLineWidth,'Color',theColor)
%     yPosition=linspace(1,0.4,length(timePoints));
%     % first, get the colours needed
%     cmapOut = BF_getcmap('dark2',7,0,0);
%     t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
%             cmapOut(i,:));
%     t.Units='normalized';
%     t.Position=[1 yPosition(i)];
%     t1=text(maxDistance(i),...
%         decayConstant(i)+0.25*10^(-3),num2str(decayConstant(i)),...
%         'HorizontalAlignment','center');
%     hold on
% end
%
% xlabel('Max distance (um)','FontSize',16)
% ylabel('Decay constant','FontSize',13)
% str=sprintf('Developing Mouse decay constant against max distance');
% title(str,'Fontsize',16)
% b=figureFullScreen(b,true);
% set(b, 'PaperPositionMode', 'auto') % to save a figure that is the same size as the figure on the screen
% % save figure
% filename=strcat('decayConstant','.jpeg');
% str=fullfile('Outs','decay_constant',filename);
% saveas(b,str)
