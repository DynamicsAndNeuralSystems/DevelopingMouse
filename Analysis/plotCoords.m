function plotCoords(coOrds)
  f=figure('color','w');
  [n,~] = size(coOrds);
  for i=1:n
    scatter3(coOrds(i,1),coOrds(i,2),coOrds(i,3))
    hold on
  end
end
