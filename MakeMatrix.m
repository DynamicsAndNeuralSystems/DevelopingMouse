function Xmatrix = MakeMatrix(Xcell) % turn cell entries into a slice in a 3D matrix
    [x,y] = size(Xcell{1});
    Xmatrix = zeros(x,y,length(Xcell));
    for k = 1:length(Xcell)
        Xmatrix(:,:,k) = Xcell{k};
    end
end