function f = crossEntropy(fromArr, ofArr)
  
   f = - arrSumAllDims(fromArr .* log(ofArr));

end