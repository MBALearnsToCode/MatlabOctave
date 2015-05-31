function f = costFuncAvg_crossEntropy_softmax...
   (hypoOutput_rowMat, targetOutput_rowMat, classSkewnesses = [1], ...
   returnGrad = false, casesDim = 1)
      
   [m n] = size(targetOutput_rowMat);
   
   for (j = (length(classSkewnesses) + 1) : n)
      classSkewnesses(j) = classSkewnesses(j - 1);
   endfor
   classSkewnesses /= sum(classSkewnesses) / n; 
    
   f.accuracyAvg = accuracyAvg_softmax...
      (hypoOutput_rowMat, targetOutput_rowMat, ...
      classSkewnesses);
      
   f.val = crossEntropy...
      (targetOutput_rowMat, hypoOutput_rowMat, ...
      classSkewnesses) / m;
      
   if (returnGrad)
      f.grad = - bsxfun(@rdivide, ...
         targetOutput_rowMat ./ hypoOutput_rowMat, ...
         classSkewnesses) / m;
   endif
   
endfunction