function f = tanhFunc_colVec(colVec)

   f.val = val = tanh(colVec);
   f.deriv = diag(1 - (val .^ 2));

endfunction