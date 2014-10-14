function f = accuracyAvg(hypoArr, targetArr)
  
   f = arrSumAllDims(targetArr .* hypoArr) ...
      + arrSumAllDims((1 - targetArr) .* (1 - hypoArr));

endfunction