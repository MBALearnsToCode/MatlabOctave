function f = accuracyAvg_logistic(hypoArr, targetArr, ...
   posSkewnesses = [0.5])
   
   posSkewnesses(posSkewnesses >= 1) = 0.5;
   posSkewnesses = 2 * posSkewnesses;
   negSkewnesses = 2 - posSkewnesses;
   
   numerator = arrSumAllDims(bsxfun(@rdivide, ...
      targetArr .* hypoArr, posSkewnesses) ...
      + bsxfun(@rdivide, (1 - targetArr) .* (1 - hypoArr), ...
      negSkewnesses));
   
   denominator = arrSumAllDims...
      (bsxfun(@rdivide, double(targetArr) == 1, ...
      posSkewnesses) ...
      + bsxfun(@rdivide, double(targetArr) == 0, ...
      negSkewnesses));
      
   f = numerator / denominator;

endfunction