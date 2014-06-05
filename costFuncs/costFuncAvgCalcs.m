function f = costFuncAvgCalcs...
   (hypoArr, targetArr, costFuncType, ...
   returnGrad = true, casesDim = 1)

   switch (costFuncType)

      case ('SE')
         funcCostAvg = @costFuncAvg_sqErr;
         
      case ('CE-L')
         funcCostAvg = @costFuncAvg_crossEntropy_logistic;

      case ('CE-S')
         funcCostAvg = @costFuncAvg_crossEntropy_softmax;
          
   endswitch

   if (returnGrad)
      calcs = funcCostAvg...
         (hypoArr, targetArr, returnGrad, casesDim);
      f.val = calcs.val;
      f.grad = calcs.grad;
   else
      f.val = funcCostAvg...
         (hypoArr, targetArr, returnGrad, casesDim).val;
   endif

end