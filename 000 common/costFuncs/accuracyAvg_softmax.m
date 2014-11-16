function f = accuracyAvg_softmax(hypoArr, targetArr);

   f = arrSumAllDims(targetArr .* hypoArr);
   
endfunction