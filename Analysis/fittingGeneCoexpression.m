% User input; must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log';
whatNorm='log2';
whichField={'normStructure'};

if strcmp(whichField{1},'normStructure')
    coeffFile=sprintf('coeffValue%s.mat',strcat('_',whichField{1}));
    confIntFile=sprintf('confInt%s.mat',strcat('_',whichField{1}));
    
elseif whatNorm==' '
    coeffFile=sprintf('coeffValue.mat');
    confIntFile=sprintf('confInt.mat');
else
    coeffFile=sprintf('coeffValue%s.mat',strcat('_',whatNorm));
    confIntFile=sprintf('confInt.mat',strcat('_',whatNorm));
end
load(coeffFile)
load(confIntFile)
load('maxDistance.mat')

timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};

%% Plotting each fitting parameter in exp with their confidence intervals in each time point
%-------------------------------------------------------------------------------
fitMethods={'linear','exp','exp_1_0','exp1'};
negCell=cell(length(timePoints),1);
posCell=cell(length(timePoints),1);
for j=2
    for i=1:length(timePoints)
        negCell{i}=coeffValue.(fitMethods{j}){i}(3)-confInt.(fitMethods{j}){i}(1,3);
        posCell{i}=confInt.(fitMethods{j}){i}(2,3)-coeffValue.(fitMethods{j}){i}(3);
    end
end
% negCell{j}{8}=coeffValue_global.(fitMethods{j})-confInt_global.(fitMethods{j})(2,:);
% posCell{j}{8}=confInt_global.(fitMethods{j})(1,:)-coeffValue_global.(fitMethods{j});
%%
f=figure('color','white');

yData=cellfun(@(x) x(3),coeffValue.(fitMethods{2}));
xData=cell2mat(maxDistance);
negError=cell2mat(negCell);
posError=cell2mat(posCell);
errorbar(xData,yData,negError,posError,'.k')
if strcmp(whichField{1},'normStructure')
    str=sprintf('c.n against maximum distance, z score normalized across structures');
elseif whatNorm==' '
    str=sprintf('c.n against maximum distance, normalized by scaled sigmoid');
else
    str=sprintf('c.n against maximum distance, normalized by %s',whatNorm);
end
title(str)
xlabel('Maximum distance (um)')
ylabel('Exponential decay constant (absolute value)')

%% conversion of decay constants from um to mm
f=figure('color','white');
yData_mm=yData*1000;
xData_mm=xData/1000;
negError_mm=negError*1000;
posError_mm=posError*1000;

errorbar(xData_mm,yData_mm,negError_mm,posError_mm,'.k')
text(xData_mm,yData_mm, num2str(yData_mm));

if strcmp(whichField{1},'normStructure')
    str=sprintf('c.n against maximum distance, z score normalized across structures');
elseif whatNorm==' '
    str=sprintf('c.n against maximum distance, normalized by scaled sigmoid');
else
    str=sprintf('c.n against maximum distance, normalized by %s',whatNorm);
end
title(str)
xlabel('Maximum distance (mm)')
ylabel('Exponential decay constant (absolute value) (1/mm)')


