function N=getDensity(xData,yData,numThresholds)
    xThresholds = arrayfun(@(x)quantile(xData,x),linspace(0,1,numThresholds));
    xThresholds(end) = xThresholds(end) + eps;
    yThresholds = arrayfun(@(x)quantile(yData,x),linspace(0,1,numThresholds));
    yThresholds(end) = yThresholds(end) + eps;
    % compute the number belonging to each bin
    binnedDataCell_x=cell(numThresholds,1);
    N=zeros(numThresholds-1,numThresholds-1);
    for j=1:numThresholds-1 % x bins
      binnedDataCell_x{j}=yData(xData>=xThresholds(j) & xData < xThresholds(j+1));
      % make the frequency matrix
      for k=1:numThresholds-1 % y bins
        N(k,j)=numel(binnedDataCell_x{j}(binnedDataCell_x{j}>=yThresholds(k) & ...
                                            binnedDataCell_x{j} < yThresholds(k+1)));
      end
    end
end
