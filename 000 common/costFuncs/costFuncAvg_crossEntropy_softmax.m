function f = costFuncAvg_crossEntropy_softmax...
   (hypoArr, targetArr, returnGrad = false, casesDim = 1)

   m = size(targetArr, casesDim);
   f.accuracyAvg = accuracyAvg_softmax(hypoArr, targetArr) / m;
   f.val = crossEntropy(targetArr, hypoArr) / m;
   if (returnGrad)
      f.grad = - (targetArr ./ hypoArr) / m;
   endif
   
endfunction