function f = linearOutputOverInputDeriv_rowMat...
   (numRows, weight_Mat)

   [nI nO] = size(weight_Mat); 
   f = zeros([numRows nO nI numRows]);
   for (i = 1 : numRows)
      for (jO = 1 : nO)
         for (jI = 1 : nI)          
            f(i, jO, jI, i) = weight_Mat(jI, jO);
         endfor
      endfor       
   endfor
       
end