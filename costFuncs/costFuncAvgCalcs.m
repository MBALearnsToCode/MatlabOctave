function f = costFuncAvgCalcs...
   (hypoArr, targetArr, ...
   targetArr_isClassIndcsColVec_ofNumClasses = 0, ...
   costFuncType, returnGrad = true, casesDim = 1)

   switch (costFuncType)

      case ('SE')
         funcCostAvg = @costFuncAvg_sqErr;
         
      case ('CE-L')
         funcCostAvg = @costFuncAvg_crossEntropy_logistic;

      case ('CE-S')
         funcCostAvg = @costFuncAvg_crossEntropy_softmax;
          
   endswitch
   
   if (targetArr_isClassIndcsColVec_ofNumClasses)
      targetArr_toUse = convertClassIndcsColVec_toRowMat...
         (targetArr, ...
         targetArr_isClassIndcsColVec_ofNumClasses);
   else
      targetArr_toUse = targetArr;
   end;
   
   if (returnGrad)
      calcs = funcCostAvg...
         (hypoArr, targetArr_toUse, returnGrad, casesDim);
      f.val = calcs.val;
      f.grad = calcs.grad;
   else
      f.val = funcCostAvg...
         (hypoArr, targetArr_toUse, returnGrad, casesDim).val;
   endif

end