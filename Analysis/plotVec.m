function plotVec(coOrds)
% this function plots vectors represented by rows of the matrix vecMat in 3D
[n,~] = size(coOrds);
C = combnk(1:n,2);
f = figure('color','w');
for i=1:size(C,1)
  vectarrow(coOrds(C(i,1),:),coOrds(C(i,2),:));
  hold on
end
end
