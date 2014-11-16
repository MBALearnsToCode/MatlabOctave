function f = linearKernMat_rowMat(rowMat1, rowMat2 = [])
   
   if isempty(rowMat2)
      rowMat2 = rowMat1;
   endif
   
   f = rowMat1 * rowMat2';
   
end