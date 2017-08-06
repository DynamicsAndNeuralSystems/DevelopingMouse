load('maxDistanceAll_decayConstantAll.mat')
figure('color','w');
plot(log(maxDistanceAll),log(decayConstantAll),'ok','DisplayName','data1');
axis square
xlabel('log (length scale)');
ylabel('log (decay constant)');
hold on
[f_handle,stats,c]=GiveMeFit(log(maxDistanceAll),log(decayConstantAll),'linear');
Gradient = c.p1; Intercept = c.p2;
plot(linspace(8.4,9.6,5),f_handle(linspace(8.4,9.6,5)),'DisplayName','linear');
str=sprintf('y=%fx+%f',Gradient,Intercept);
text(8.8,-6,str);
legend('show')
