function [adjRSquare,fitObject,fHandle] = fitting_stat(whatfitMethods,xData,yData)
% USAGE: % whatfitMethods is a cell containing one or more methods as strings
% Initialize
adjRSquare=struct();
fitObject=struct();
fHandle=struct();
for j = 1:length(whatfitMethods)
    [f_handle,Stats,c] = GiveMeFit(xData,yData,whatfitMethods{j},true);
    fitObject.(whatfitMethods{j})=c;
    fHandle.(whatfitMethods{j})=f_handle;
    adjRSquare.(whatfitMethods{j})=Stats.adjrsquare;
    % confInt.(whatfitMethods{j})=confint(c,0.95);
    % coeffValue.(whatfitMethods{j})=coeffvalues(c);
end
%     %%
%     matAdjRSquare=zeros(length(timePointNow),length(whatfitMethods));
%     for k=1:length(timePointNow)
%         for j=1:length(whatfitMethods)
%             matAdjRSquare(k,j)=adjRSquare.(whatfitMethods{j})(k);
%         end
%     end
end
