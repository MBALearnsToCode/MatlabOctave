function [rowMat_norm mean_colWise sd_colWise] = ...
   normalizeMeanSd(rowMat, mean_colWise = [], sd_colWise = [])

   if isempty(mean_colWise)
      mean_colWise = mean(rowMat);
   endif
   rowMat_norm = bsxfun(@minus, rowMat, mean_colWise);
   if isempty(sd_colWise)
      sd_colWise = std(rowMat_norm);
   endif
   rowMat_norm = bsxfun(@rdivide, rowMat_norm, sd_colWise);

endfunction