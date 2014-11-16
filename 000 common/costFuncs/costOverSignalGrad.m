function f = costOverSignalGrad...
   (hypoOutput_rowMat, targetOutput_rowMat, ...
   costFuncType = 'CE-L', skewnesses = [1])
   
   [m n] = size(targetOutput_rowMat);
   
   if strcmp(costFuncType, 'CE-S')
      for (j = (length(skewnesses) + 1) : n)
         skewnesses(j) = skewnesses(j - 1);
      endfor
      skewnesses /= (sum(skewnesses) / n);      
   endif   
   
   switch (costFuncType)
   
      case ('SE')
         f = (hypoOutput_rowMat - targetOutput_rowMat) / m;
         
      case ('CE-L')
         balancedClasses = ...
            equalTest(skewnesses, 2 - skewnesses);
         if (balancedClasses)
            f = (hypoOutput_rowMat - targetOutput_rowMat) / m;
         else
            f = (bsxfun(@rdivide, ...
               targetOutput_rowMat .* (hypoOutput_rowMat - 1), ...
               skewnesses) ...
               + bsxfun(@rdivide, ...
               (1 - targetOutput_rowMat) .* hypoOutput_rowMat, ...
               2 - skewnesses)) / m;
         endif
      
      case ('CE-S')
         balancedClasses = ...
            equalTest(max(skewnesses), min(skewnesses));
         if (balancedClasses)
            f = (hypoOutput_rowMat - targetOutput_rowMat) / m;
         else
            hypoOutput_rep = ...
               arrRepAcrossNewDims...
               (hypoOutput_rowMat, 2, n); 
            targetOutput_rep = ...
               permute(arrRepAcrossNewDims...
               (targetOutput_rowMat, 2, n), [1 3 2]);
            iMat_rep = permute(arrRepAcrossNewDims...
               (eye(n), 2, m), [3 1 2]);
            skewnesses_rep = permute(arrRepAcrossNewDims...
               (repmat(skewnesses, [m 1]), 2, n), [1 3 2]);
            f = arrSumAcrossDims...                        
               ((targetOutput_rep ...
               .* (hypoOutput_rep - iMat_rep)) ...
               ./ skewnesses_rep, 3) / m;
         endif
         
   endswitch
   
endfunction