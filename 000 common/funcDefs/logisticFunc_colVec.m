function f = logisticFunc_colVec(colVec)

   f.val = val = 1 ./ (1 + exp(-colVec));
   f.deriv = diag(val .* (1 - val));

end