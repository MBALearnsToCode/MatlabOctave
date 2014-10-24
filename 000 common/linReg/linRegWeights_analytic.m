function f = linRegWeights_analytic(Y, X, addBias = true)

   X = addBiasElems(X, addBias);
   f = pinv(X' * X) * X' * Y;

endfunction