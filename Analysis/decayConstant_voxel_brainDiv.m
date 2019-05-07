clear
load('fitting_brainDiv.mat','maxDistance_brainDiv','decayConstant_brainDiv')
brainDivisions={'forebrain','midbrain','hindbrain'};
for k=1:length(brainDivisions)
  f=figure('color','w','Position',get(0,'Screensize'));
  plot(log(maxDistance_brainDiv.voxel.(brainDivisions{k})),log(decayConstant_brainDiv.voxel.(brainDivisions{k})),'ok','DisplayName','data1');
  axis square
  xlabel('log (length scale)');
  ylabel('log (decay constant)');
  hold on
  [f_handle,stats,c]=GiveMeFit(log(maxDistance_brainDiv.voxel.(brainDivisions{k})),log(decayConstant_brainDiv.voxel.(brainDivisions{k})),'linear');
  Gradient = c.p1; Intercept = c.p2;
  plot(linspace(7,9.4,5),f_handle(linspace(7,9.4,5)),'DisplayName','linear');
  str=sprintf('y=%fx+%f',Gradient,Intercept);
  text(8.8,-6,str);
  legend('show')
  str=sprintf('Developing Mouse decay constant against max distance, %s', brainDivisions{k});
  title(str,'Fontsize',16)
  % save figure
  filename=strcat('decayConstant_log','_',brainDivisions{k},'.jpeg');
  str=fullfile('Outs','decay_constant_log_brainDiv',filename);
  saveas(f,str)
end
