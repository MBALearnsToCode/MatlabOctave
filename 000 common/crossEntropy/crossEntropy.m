function f = crossEntropy(fromArr, ofArr, ...
   classSkewnesses = [1], tiny = exp(-36))
  
   f = - arrSumAllDims(bsxfun(@rdivide, ...
      fromArr .* log(ofArr + tiny), classSkewnesses));

endfunction