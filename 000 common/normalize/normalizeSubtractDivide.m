function [rowMat_norm mean_colWise sd_or_range_colWise] = ...
   normalizeSubtractDivide(rowMat, mean_colWise = [], ...
   sd_or_range_colWise = [], sd_or_range = 'sd')

   if isempty(mean_colWise)
      mean_colWise = mean(rowMat);
   endif
   rowMat_norm = bsxfun(@minus, rowMat, mean_colWise);
   if isempty(sd_or_range_colWise)
      switch (sd_or_range)
         case ('sd')
            sd_or_range_colWise = std(rowMat_norm);
         case ('range')
            sd_or_range_colWise = range(rowMat_norm);
      endswitch
   endif
   rowMat_norm = bsxfun(@rdivide, rowMat_norm, ...
      sd_or_range_colWise);

endfunction