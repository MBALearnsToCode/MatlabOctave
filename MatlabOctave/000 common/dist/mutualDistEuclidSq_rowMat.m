function f= mutualDistEuclidSq_rowMat(rowMat1, rowMat2 = [])

   if isempty(rowMat2)
      rowMat2 = rowMat1;
   endif

    rowSumSq1_colVec = sum(rowMat1 .^ 2, 2);
    rowSumSq2_colVec = sum(rowMat2 .^ 2, 2);
    f = bsxfun(@plus, rowSumSq1_colVec, ...
       bsxfun(@plus, rowSumSq2_colVec', ...
       - 2 * rowMat1 * rowMat2'));

end