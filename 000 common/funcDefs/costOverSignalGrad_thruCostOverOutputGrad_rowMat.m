function f = ...
   costOverSignalGrad_thruCostOverOutputGrad_rowMat...
   (costOverOutputGrad, funcType, funcDeriv_effForm)

   switch (funcType)

      case ('linear')
         f = costOverOutputGrad;

      case ('logistic')
         f = costOverOutputGrad .* funcDeriv_effForm;
         
      case ('tanh')
         f = costOverOutputGrad .* funcDeriv_effForm;

      case ('softmax')
         f = permute(arrSumAcrossDims(arrRepAcrossNewDims...
            (costOverOutputGrad, 2, ...
            size(funcDeriv_effForm, 3)) ...
            .* funcDeriv_effForm, 2), [1 3 2]);

   endswitch

endfunction