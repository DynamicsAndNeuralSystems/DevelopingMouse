load('voxelGeneCoexpression_all.mat');
% Initialize
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
fitting_stat_all = struct();
distances_all = cell(7,1);
% Get correlation coefficient and distances
for i = 1:length(timePoints)
    % extract the correlation coefficients
    geneCorr=corrcoef((voxGeneMat_all{i}(dataIndSelect_all{i},:))','rows','pairwise');
    corrCoeff=geneCorr(find(triu(ones(size(geneCorr)),1)));
    % extract distances from distance matrix
    distances_all{i} = extractDistances(distMat_all{i});
    [fitting_stat_all.(timePoints{i}).adjRSquare, fitting_stat_all.(timePoints{i}).fitObject,fitting_stat_all.(timePoints{i}).fHandle]=fitting_stat({'linear','exp_1_0','exp1','exp'}, '', distances, corrCoeff);
end

% %% exponential fit (3 parameter)
% % collect fit objects
% decayConstant=struct();
% b=figure('color','w');
% for i=1:7
%     temp=fitObjectHere.(timePoints{i}).fitObject.exp;
%     decayConstant.(timePoints{i})=temp.n;
%     theColor=cmapOut(i,:);
% 
%     plot(max(extractfield(distanceAll.(timePoints{i}),'distance')),decayConstant.(timePoints{i}),'-o','MarkerSize',10,'LineStyle',theStyle,...
%         'LineWidth',theLineWidth,'Color',theColor)
%     yPosition=linspace(1,0.4,length(timePoints));
% 
%     t=text(0.5,0.5,char(timePoints{i}),'color','k','FontSize',14,'BackgroundColor',...
%             cmapOut(i,:));
%     t.Units='normalized';
%     t.Position=[1 yPosition(i)];
%     t1=text(max(extractfield(distanceAll.(timePoints{i}),'distance')),...
%         decayConstant.(timePoints{i})+0.25*10^(-3),num2str(decayConstant.(timePoints{i})),...
%         'HorizontalAlignment','center');
%     hold on
% end
% 
% xlabel('Max distance (um)','FontSize',16)
% ylabel('Decay constant','FontSize',13)
% str=sprintf('Developing Mouse decay constant against max distance');
% title(str,'Fontsize',16)
% b=figureFullScreen(b,true);
