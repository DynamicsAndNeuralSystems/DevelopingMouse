function Xmatrix=Make4DMatrix(Xcell)
    [x,y,z]=size(Xcell{1});
    Xmatrix = zeros(x,y,z,length(Xcell));
    for k=1:length(Xcell)
        Xmatrix(:,:,:,k)=Xcell{k};
    end
end