clear
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
load('fitting.mat','maxDistance','decayConstant')

f=figure('color','w');
plot(log(maxDistance.voxel),log(decayConstant.voxel),'ok','DisplayName','data1');
axis square
xlabel('log (length scale)');
ylabel('log (decay constant)');
hold on
[f_handle,stats,c]=GiveMeFit(log(maxDistance.voxel),log(decayConstant.voxel),'linear');
Gradient = c.p1; Intercept = c.p2;
plot(linspace(8.4,9.6,5),f_handle(linspace(8.4,9.6,5)),'DisplayName','linear');
str=sprintf('y=%fx+%f',Gradient,Intercept);
text(8.8,-6,str);
legend('show')
str=sprintf('Developing Mouse decay constant against max distance, %s', 'wholeBrain');
title(str,'Fontsize',16)

% save figure
filename=strcat('decayConstant_log','.jpeg');
str=fullfile('Outs','decay_constant_log',filename);
saveas(f,str)
