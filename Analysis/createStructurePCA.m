load('voxGeneMat_structures_all.mat')
load('dataDevMouse.mat');
timePoints={'E11pt5','E13pt5','E15pt5','E18pt5','P4','P14','P28'};
acronym_ordered=cell(length(timePoints),1);
color_ordered=cell(length(timePoints),1);
explained_percentage=cell(length(timePoints),1);
for i=1:length(timePoints)
  f=figure('color','w','Position',get(0,'Screensize'));
[coeff,~,~,~,explained_percentage{i},~]=pca((voxGeneMat_structure{i}),'algorithm','als','NumComponents',1);
  distMat = dataDevMouse.(timePoints{i}).distance;
  % match the structure acronyms so that distances are in correct order
  [~,ia,ib]=intersect(acronyms{i},dataDevMouse.(timePoints{i}).acronym,'stable');
  coeff=coeff(ia);
  distMat=distMat([ib],[ib]);
  acronym_ordered{i}=dataDevMouse.(timePoints{i}).acronym(ib);
  color_ordered{i}=dataDevMouse.(timePoints{i}).color(ib);
  score = mdscale(distMat,2);
  xData = score(:,1);
  yData = score(:,2);
  nodeSize = 50;
  scatter(xData,yData,nodeSize,coeff,'filled')
  colormap(hot(size(score,1)))
  colorbar
  title(sprintf('MDS plot colored by coeff of PC1, developing mouse %s',timePoints{i}))
  % Add labels:
  xDataRange = range(xData);
  dotColors = arrayfun(@(x) rgbconv(color_ordered{i}{x})',1:length(xData),'UniformOutput',0);
  dotColors = [dotColors{:}]';
  for j = 1:length(xData)
      text(xData(j)+0.04*xDataRange,yData(j),acronym_ordered{i}{j},...
                      'color',brighten(dotColors(j,:),-0.5),'FontSize',10)
  end
  F=getframe(f);
  str=fullfile('Outs','structure_PCA',strcat('structure_PCA_',timePoints{i},'.jpeg'));
  imwrite(F.cdata,str)
end
