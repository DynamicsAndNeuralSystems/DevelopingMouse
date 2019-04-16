
%% fitting

adjRSquare=struct();
fitObject=struct();
fitMethods={'linear','exp_1_0','exp1','exp'};
fHandle=struct();
%%

for j=1:length(fitMethods)
    [f_handle,Stats,c] = GiveMeFit(distance,corrCoeff,fitMethods{j},true);
    fitObject.(fitMethods{j})=c;
    fHandle.(fitMethods{j})=f_handle;
    adjRSquare.(fitMethods{j})=Stats.adjrsquare;
    confInt.(fitMethods{j})=confint(c,0.95);
    coeffValue.(fitMethods{j})=coeffvalues(c);
end

%%
matAdjRSquare=zeros(length(timePointNow),length(fitMethods)); 
for k=1:length(timePointNow)
    for j=1:length(fitMethods)
        matAdjRSquare(k,j)=adjRSquare.(fitMethods{j})(k);
    end
end

%%
% User input; must leave it as empty string ' ' if 'scaledSigmoid'; options:' ', 'zscore','log2';
whatNorm=' ';
% User input: which field from DevMouseGeneExpression you want to use: 'norm' or normStructure';
% 'norm' is normalized across genes using a method specified in file name,
% or otherwise ScaledSigmoid; if normStructure is chosen, it doesn't matter
% what "whatNorm" is as long as the DevMouseGeneExpression.mat is up to
% date (i.e. contains the field "normStructure") [at the moment, only whatNorm='log2' is up to date]
% User input: Choose whether to plot the graph, which takes much longer running time) (plot=1;no plot=0)
plotGraph=0;


g=figure('color','w');
xAxis=[1:length(timePointNow)];
%BarChart=bar(matAdjRSquare,'grouped');
BarChart=bar(vertcat(matAdjRSquare,nan(size(matAdjRSquare))));

BarChat.BarWidth = 0.4;
ax = gca;

ax.XTick=[1];
ax.XTickLabel=timePointNow;

xt=[1];

if whatNorm==' ';
    str=sprintf('Degree of freedom adjusted R-square, scaled sigmoid');
else
    str=sprintf('Degree of freedom adjusted R-square, %s',whatNorm);
end
Title=title(str);
set(Title, 'FontSize', 16)
grid on
grid minor

L = cell(1,4);
L{1}='linear';
L{2}='1 parameter exponential';
L{3}='2 parameter exponential';
L{4}='3 parameter exponential';
legend(BarChart,L,'Location','northeast')
hold on

g=figureFullScreen(g,true); 

%% plot exponential fit
w=figure('color','w');
gcf;
scatter(distance,corrCoeff,'.')
hold on
xData=linspace(min(distance),max(distance),0.1*length(distance));
p=plot(xData,fHandle.exp(xData),'-x'); 
set(p,'Color','k')
legend(p,'Exponential fit')
xlabel('Separation Distance (um)','FontSize',16)
ylabel('Gene Coexpression (Pearson correlation coefficient)','FontSize',13)
str = sprintf('Developing Mouse %s',timePoints{i});
title(str,'Fontsize',19);
w=figureFullScreen(w,true); 


%% save variables and figures
cd 'D:\Data\DevelopingMousePhase2\makeGridData1_var'
str=strcat('makeGridData1_',timePoints{i},'.mat');
save(str)
cd 'D:\Data\DevelopingMousePhase2\makeGridData1_fig'
str=strcat('GeneCoexpress_',timePoints{i},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
saveas(f,str)
str=strcat('R-square_exp_voxel_',timePoints{i},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
saveas(g,str)
str=strcat('expoFit_voxel_',timePoints{i},'_random1000_annoOnly_30%filter_noSC_massiveVer.jpg');
saveas(w,str)