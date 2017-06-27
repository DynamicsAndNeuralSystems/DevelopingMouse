% Match:
[~,ia,ib] = intersect(structInfo.acronym,regAcronyms,'stable');
structInfo = structInfo(ia,:);
coOrds = coOrds(ib,:);
numRegions = height(structInfo);

f = figure('color','w');
dotColors = arrayfun(@(x)rgbconv(structInfo.color_hex_triplet{x})',...
                                        1:numRegions,'UniformOutput',0);
dotColors = [dotColors{:}]';

nodeSize = 50;
scatter3(coOrds(:,1),coOrds(:,2),coOrds(:,3),nodeSize,dotColors,'fill','MarkerEdgeColor','k')