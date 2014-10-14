function f = gaussKernMat_rowMat(rowMat1, rowMat2 = [], ...
   sigma = 1)
   
   if isempty(rowMat2)
      rowMat2 = rowMat1;
   endif
   
   f = exp(-0.5 / (sigma ^ 2)) ...
       .^ mutualDistEuclidSq_rowMat(rowMat1, rowMat2);
    
end