function f = softmaxFunc_colVec(colVec)

   vec_subtractMax = colVec - max(colVec);
   expVec = exp(vec_subtractMax);
   f.val = val = expVec / sum(expVec);   
   f.deriv = diag(val) - val * val';

end