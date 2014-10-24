function [rowMat_norm mean_colWise range_colWise] = ...
   normalizeMeanRange(rowMat, ...
   mean_colWise = [], range_colWise = [])

   if isempty(mean_colWise)
      mean_colWise = mean(rowMat);
   endif
   rowMat_norm = bsxfun(@minus, rowMat, mean_colWise);
   if isempty(range_colWise)
      range_colWise = range(rowMat_norm);
   endif
   rowMat_norm = bsxfun(@rdivide, rowMat_norm, ...
      range_colWise);

endfunction