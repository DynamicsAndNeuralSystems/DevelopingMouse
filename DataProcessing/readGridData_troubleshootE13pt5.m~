% sanity check
sizeGrid = [89,109,69];
resolutionGrid=100;
% user input: number of data used in analysis
numData=1000;
timePoints={'E13pt5'};
%% load variables
% load('energyGrids_E13pt5.mat')
% load('geneIDInfo_E13pt5.mat')
% load('timePointInfo_E13pt5.mat')
load('annotationGrids.mat')
load('spinalCordID.mat')
isAnno=annotationGrids{2}>0;
isSpinalCord=ismember(annotationGrids{2},spinalCord_ID);
[a,b,c]=ind2sub(sizeGrid,find(isAnno & ~isSpinalCord));
coOrdsAnno=horzcat(a,b,c);
 
dataIndSelectIsAnno=datasample([1:size(coOrdsAnno,1)],numData,'replace',false);
distMatIsAnno=squareform(pdist(coOrdsAnno(dataIndSelectIsAnno,:),'euclidean')*resolutionGrid);
distanceIsAnno=distMatIsAnno(find(triu(ones(size(distMatIsAnno)),1)));

f=figure('color','w');
scatter(distanceIsAnno,distanceIsAnno)

%% extract the ID of the annotated structures (for querying their acronyms)
%annoID_E13pt5=annotationGrids{2}(isAnno);

