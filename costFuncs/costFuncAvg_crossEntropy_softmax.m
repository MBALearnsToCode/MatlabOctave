function f = costFuncAvg_crossEntropy_softmax...
   (hypoArr, targetArr, returnGrad = true, casesDim = 1)

   m = size(targetArr, casesDim);
   f.val = crossEntropy(targetArr, hypoArr) / m;
   if (returnGrad)
      f.grad = - (targetArr ./ hypoArr) / m;
   endif
   
end