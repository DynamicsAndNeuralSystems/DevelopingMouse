function matrixMean = MeanCellMatrices(Xcell) % mean the 3D matrix across the third dimension
    Xmatrix = MakeMatrix(Xcell);
    matrixMean = mean(Xmatrix,3);
end