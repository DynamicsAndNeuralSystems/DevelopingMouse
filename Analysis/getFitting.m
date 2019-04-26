function [fitting_stat_all, decayConstant, maxDistance]=getFitting(xData,yData)
  % xData and yData are cells each containing distances and correlation coefficient of all time points
  % dataProcessing: 'original' or 'binned numThresholds=xx'
  timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
  % initialize
  fitting_stat_all = struct();
  decayConstant=zeros(length(timePoints),1);
  maxDistance = zeros(length(timePoints),1);
  for i = 1:length(timePoints)
      [fitting_stat_all.(timePoints{i}).adjRSquare, ...
      fitting_stat_all.(timePoints{i}).fitObject,...
      fitting_stat_all.(timePoints{i}).fHandle]=fitting_stat({'linear','exp_1_0','exp1','exp'}, ...
                                                xData{i}, yData{i});
      % collect decay constant
      decayConstant(i)=fitting_stat_all.(timePoints{i}).fitObject.exp.n;
      % collect max distance
      maxDistance(i)=max(xData{i});
  end
end
