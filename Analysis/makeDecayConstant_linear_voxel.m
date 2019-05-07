function makeDecayConstant_linear_voxel(numData,numThresholds,useGoodGeneSubset)
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
if useGoodGeneSubset
  filestr1=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
              num2str(numThresholds),'_scaled_goodGeneSubset','.mat');
else
  filestr1=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
              num2str(numThresholds),'_scaled','.mat')
end
filestr2=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
            num2str(numThresholds),'_goodGeneSubset','.mat');
load(filestr1,'decayConstant')
load(filestr2, 'maxDistance')
f=figure('color','w','Position',get(0,'Screensize'));
plot(maxDistance,decayConstant,'ok','DisplayName','Eta');
axis square
xlabel('length scale');
ylabel('decay constant');
hold on
[f_handle,stats,c]=GiveMeFit(maxDistance,decayConstant,'linear');
Gradient = c.p1; Intercept = c.p2;
plot(linspace(0,12000,5),f_handle(linspace(0,12000,5)),'DisplayName','linear');
str=sprintf('y = %fx+%f',Gradient,Intercept);
text(5000,12,str,'FontSize',14);
str=sprintf('Adjusted R square = %d',stats.adjrsquare);
text(5000,11,str,'FontSize',14);

legend('show')
if useGoodGeneSubset
  str=sprintf('Decay constant against max distance, %s, numData=%d, numThresholds=%d, goodGeneSubset',...
              'wholeBrain',numData,numThresholds);
else
  str=sprintf('Decay constant against max distance, %s, numData=%d, numThresholds=%d',...
            'wholeBrain',numData,numThresholds);
end
title(str,'Fontsize',15)

% save figure
F=getframe(f);
if useGoodGeneSubset
  filename=strcat('decayConstant_linear_scaled_goodGeneSubset','.jpeg');
  str=fullfile('Outs','decay_constant_linear_scaled_goodGeneSubset',filename);
else
  filename=strcat('decayConstant_linear_scaled','.jpeg');
  str=fullfile('Outs','decay_constant_linear_scaled',filename);
end
imwrite(F.cdata,str)
end
