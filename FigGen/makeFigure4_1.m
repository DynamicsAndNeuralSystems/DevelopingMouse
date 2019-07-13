function makeFigure4_1(numData,numThresholds)
brainDivisions=GiveMeParameter('brainDivisions');
thisCellType='allCellTypes';
thisDirection='allDirections';
timePoints = GiveMeParameter('timePoints');
constantTypes = GiveMeParameter('constantTypes');

if nargin < 2
  numThresholds=GiveMeParameter('numThresholds');
end
if nargin < 1
  numData=GiveMeParameter('numData');
end

%-------------------------------------------------------------------------------
% create a structure to hold the data
constantOut = struct();

for k=1:length(brainDivisions)
  f = figure('color','w');

  for j=1:length(constantTypes)
    subplot(1,3,j)
    constantOut.(constantTypes{j}).(brainDivisions{k}) = makeConstantPlot(numData,numThresholds,...
                                                                          brainDivisions{k},...
                                                                          false,thisCellType,thisDirection,false,...
                                                                          constantTypes{j},false,false);
    hold on
  end
  str = GiveMeLabelName(brainDivisions{k});
  title(str)
  str = fullfile('Outs','figure4',sprintf('figure4_%d.svg',k));
  saveas(f,str)
end



  T = struct2table(constantOut)
  % % create a table to hold the data
  % T = cell2table(cell(0,3));
  % T.Properties.VariableNames = constantTypes;
  % % T.Properties.RowNames = brainDivisions;
  % for j=1:length(constantTypes)
  %   for k=1:length(brainDivisions)
  %     T.(constantTypes{1}) = constantOut.(constantTypes{j}).(brainDivisions{k})(i);
  %     T.(constantTypes{2}) = constantOut.(constantTypes{j}).(brainDivisions{k})(i);
  %     T.(constantTypes{3}) = constantOut.(constantTypes{j}).(brainDivisions{k})(i);
  %   end
  % end
  % T(1:4,:) % display the table


end
