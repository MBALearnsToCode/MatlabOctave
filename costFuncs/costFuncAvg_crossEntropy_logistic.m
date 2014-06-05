function f = costFuncAvg_crossEntropy_logistic...
   (hypoArr, targetArr, returnGrad = true, casesDim = 1)

   m = size(targetArr, casesDim);
   f.val = (crossEntropy(targetArr, hypoArr) ...
      + crossEntropy(1 - targetArr, 1 - hypoArr)) / m;
   if (returnGrad)
      f.grad = - (targetArr ./ hypoArr ...
         - (1 - targetArr) ./ (1 - hypoArr)) / m;
   endif
   
end