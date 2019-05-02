function makeDecayConstant_voxel(numData,numThresholds,useGoodGeneSubset)
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
if useGoodGeneSubset
  filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
              num2str(numThresholds),'_goodGeneSubset','.mat');
else
  filestr=strcat('fitting_NumData_',num2str(numData),'_binnedData_numThresholds_',...
              num2str(numThresholds),'.mat')
end
load(filestr,'maxDistance','decayConstant')
f=figure('color','w','Position',get(0,'Screensize'));
plot(log(maxDistance),log(decayConstant),'ok','DisplayName','data1');
axis square
xlabel('log (length scale)');
ylabel('log (decay constant)');
hold on
[f_handle,stats,c]=GiveMeFit(log(maxDistance),log(decayConstant),'linear');
Gradient = c.p1; Intercept = c.p2;
plot(linspace(8.2,9.799,7),f_handle(linspace(8.2,9.799,7)),'DisplayName','linear');
str=sprintf('y=%fx+%f',Gradient,Intercept);
text(8.8,-6,str);
legend('show')
if useGoodGeneSubset
  str=sprintf('Decay constant against max distance, %s, numData=%d, numThresholds=%d, goodGeneSubset',...
              'wholeBrain',numData,numThresholds);
else
  str=sprintf('Decay constant against max distance, %s, numData=%d, numThresholds=%d',...
            'wholeBrain',numData,numThresholds);
end
title(str,'Fontsize',16)

% save figure
F=getframe(f);
if useGoodGeneSubset
  filename=strcat('decayConstant_log_goodGeneSubset','.jpeg');
  str=fullfile('Outs','decay_constant_log_goodGeneSubset',filename);
else
  filename=strcat('decayConstant_log','.jpeg');
  str=fullfile('Outs','decay_constant_log',filename);
end
imwrite(F.cdata,str)
end
