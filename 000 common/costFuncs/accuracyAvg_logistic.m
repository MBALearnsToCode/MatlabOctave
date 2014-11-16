function f = accuracyAvg_logistic(hypoArr, targetArr)
  
   f = arrSumAllDims(targetArr .* hypoArr) ...
      + arrSumAllDims((1 - targetArr) .* (1 - hypoArr));

endfunction