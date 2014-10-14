function f = linearFunc_colVec(colVec)

   f.val = colVec;  
   f.deriv = eye(length(colVec));

end