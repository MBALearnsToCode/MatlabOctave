function f = crossEntropy(fromArr, ofArr, tiny = exp(-36))
  
   f = - arrSumAllDims(fromArr .* log(ofArr + tiny));

end