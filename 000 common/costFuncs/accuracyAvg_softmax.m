function f = accuracyAvg_softmax...
   (hypoOutput_rowMat, targetOutput_rowMat, ...
   classSkewnesses = [1]);
   
   [m n] = size(targetOutput_rowMat);
   
   for (j = (length(classSkewnesses) + 1) : n)
      classSkewnesses(j) = classSkewnesses(j - 1);
   endfor
   classSkewnesses /= sum(classSkewnesses) / n;
   
   denominator = sum(1 ./ classSkewnesses) / n;
   
   f = (arrSumAllDims(bsxfun(@rdivide, ...
      targetOutput_rowMat .* hypoOutput_rowMat, ...
      classSkewnesses)) / denominator) / m;
   
endfunction