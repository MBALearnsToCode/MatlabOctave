function f = costFuncAvg_crossEntropy_logistic...
   (hypoArr, targetArr, returnGrad = false, casesDim = 1)

   m = size(targetArr, casesDim);
   f.accuracyAvg = accuracyAvg_logistic(hypoArr, targetArr) / m;
   f.val = (crossEntropy(targetArr, hypoArr) ...
      + crossEntropy(1 - targetArr, 1 - hypoArr)) / m;
   if (returnGrad)
      f.grad = - (targetArr ./ hypoArr ...
         - (1 - targetArr) ./ (1 - hypoArr)) / m;
   endif   
   
endfunction