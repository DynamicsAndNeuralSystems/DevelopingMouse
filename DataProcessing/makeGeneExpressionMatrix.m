function makeGeneExpressionMatrix(whatNorm,...
                                  whatVoxelThreshold,...
                                  whatGeneThreshold,...
                                  useGoodGeneSubset,...
                                  thisBrainDiv) % both thresholds set to 0.3
%whatNorm='scaledSigmoid'; % normalizing method for makeGridData
%-------------------------------------------------------------------------------
% Create gene coexpression matrix
%-------------------------------------------------------------------------------
%%
% Initialize
timePoints = GiveMeParameter('timePoints');

% full size for 7 time points: 210000, 669369, 806520, 115240, 165550, 136000, 158629
% after filtering off spinal cord, unannotated voxels and only including forebrain,midbrain and hindbrain
% the number of voxels are (from voxelGeneCoexpression_all): 5031,9471,11314,11288,19754,21557,24826
% numData_brainDiv=[587,1000,1000,1000,1000,1000,1000]; % number of data ...
%for each time point when division of brain is under question...
%(instead of all brain)

% create gene coexpression matrix
for i=1:length(timePoints)
    [voxGeneMat, coOrds, propNanGenes, isGoodGene] = makeGridData(timePoints{i}, ...
                                                                  whatNorm, ...
                                                                  whatVoxelThreshold,...
                                                                  whatGeneThreshold,...
                                                                  thisBrainDiv,...
                                                                  useGoodGeneSubset);
    if useGoodGeneSubset
      if strcmp(thisBrainDiv,'wholeBrain')
        str=fullfile('Matlab_variables', strcat('voxelGeneCoexpression_goodGeneSubset_',...
                    timePoints{i},'.mat'));
      else
        str=fullfile('Matlab_variables', strcat('voxelGeneCoexpression_',thisBrainDiv,'_',...
                      'goodGeneSubset_',timePoints{i},'.mat'));
      end
    else
      if strcmp(thisBrainDiv,'wholeBrain')
        str=fullfile('Matlab_variables', strcat('voxelGeneCoexpression_',timePoints{i},'.mat'));
      else
        str=fullfile('Matlab_variables', strcat('voxelGeneCoexpression_',thisBrainDiv,'_',...
                      timePoints{i},'.mat'));
      end
    end
    save(str,'voxGeneMat','coOrds','propNanGenes','isGoodGene','-v7.3');
    clear voxGeneMat coOrds numNanGenes isGoodGene
end
end

% Ignore brain divisions for now
% %% create gene expression matrix for each brain divisions
% for k=1:length(brainDivisions)
%     for i=1:length(timePoints)
%         [voxGeneMat, distMat, dataIndSelect] = makeGridData(timePoints{i}, numData_brainDiv(i), ...
%                                                             whatNorm, 0.3, brainDivisions{k},0);
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).voxGeneMat_all{i} = voxGeneMat;
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).distMat_all{i} = distMat;
%         voxelGeneCoexpression_all_brainDiv.(brainDivisions{k}).dataIndSelect_all{i} = dataIndSelect;
%     end
% end
%
% % save variables
% str=fullfile('Matlab_variables', 'voxelGeneCoexpression_all_brainDiv.mat');
% save(str,'voxelGeneCoexpression_all_brainDiv','-v7.3');
