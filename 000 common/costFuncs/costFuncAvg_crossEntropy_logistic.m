function f = costFuncAvg_crossEntropy_logistic...
   (hypoArr, targetArr, posSkewnesses = [1], ...
   returnGrad = false, casesDim = 1)   

   negSkewnesses = 2 - posSkewnesses;
   
   m = size(targetArr, casesDim);
   
   f.accuracyAvg = accuracyAvg_logistic...
      (hypoArr, targetArr, posSkewnesses);
      
   f.val = (crossEntropy(targetArr, hypoArr, posSkewnesses) ...
      + crossEntropy(1 - targetArr, 1 - hypoArr, ...
      negSkewnesses)) / m;
      
   if (returnGrad)
      f.grad = - (bsxfun(@rdivide, ...
         targetArr ./ hypoArr, posSkewnesses) ...
         - bsxfun(@rdivide, ...
         (1 - targetArr) ./ (1 - hypoArr), ...
         negSkewnesses)) / m;
   endif   
   
endfunction