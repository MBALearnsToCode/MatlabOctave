function f = linearRegWeights_analytic(X, Y, addBias = true)

   X = addBiasElems(X, addBias);
   f = pinv(X' * X) * X' * Y;

end