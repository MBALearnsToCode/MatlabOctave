function f = accuracyAvg_softmax...
   (hypoOutput_rowMat, targetOutput_rowMat, ...
   classSkewnesses = [1]);
   
   [m n] = size(targetOutput_rowMat);
   
   for (j = (length(classSkewnesses) + 1) : n)
      classSkewnesses(j) = classSkewnesses(j - 1);
   endfor
   classSkewnesses /= sum(classSkewnesses) / n;
   
   numerator = sum(bsxfun(@rdivide, ...
      sum(targetOutput_rowMat .* hypoOutput_rowMat, 1), ...
      classSkewnesses));
   
   denominator = sum(bsxfun(@rdivide, ...
      sum(targetOutput_rowMat, 1), ...
      classSkewnesses));
   
   f = numerator / denominator;
   
endfunction