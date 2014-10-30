function f = linRegWeights_analytic(Y, X, ...
   weightRegulParam_L2 = 0, addBias = true)
   
   X = addBiasElems(X, addBias);
   [m n] = size(X);
   identityMat_exclBias = eye(n);
   if (addBias)
      identityMat_exclBias(1, 1) = 0;
   endif   
   f = pinv(X' * X ...
      + m * weightRegulParam_L2 * identityMat_exclBias) ...
      * (X' * Y);
   
endfunction