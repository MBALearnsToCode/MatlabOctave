function f = accuracyAvg(hypoArr, targetArr);

   f = arrSumAllDims(targetArr .* hypoArr);
   
endfunction