function f = costFuncAvg_sqErr...
   (hypoArr, targetArr, returnGrad = true, casesDim = 1)

   m = size(targetArr, casesDim);
   f.val = distAbs(hypoArr, targetArr, 'EuclidSq') ...
      / (2 * m);
   if (returnGrad)   
      f.grad = (hypoArr - targetArr) / m;
   endif
   
end