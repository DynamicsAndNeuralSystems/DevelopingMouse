load('voxGeneMat_structures_all.mat')
load('dataDevMouse.mat');
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
for i=1:length(timePoints)
  f=figure('color','w','Position',get(0,'Screensize'));
  coeff=ppca((voxGeneMat_structure{i})',1);
  distMat = dataDevMouse.(timePoints{i}).distance;
  % match the structure acronyms so that distances are in correct order
  [~,ia,ib]=intersect(dataDevMouse.(timePoints{i}).acronym,acronyms{i},'stable');
  coeff=coeff(ib);
  distMat=distMat([ia],[ia]);
  score = mdscale(distMat,2);
  xData = score(:,1);
  yData = score(:,2);
  nodeSize = 50;
  scatter(xData,yData,nodeSize,coeff)
  F=getframe(f);
  str=fullfile('Outs','structure_PCA',strcat('structure_PCA_',timePoints{i},'.jpeg'));
  imwrite(F.cdata,str)
end
