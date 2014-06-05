function f = linearOutputOverWeightDeriv_rowMat...
   (numOutputCols, input_rowMat)

   [m nI] = size(input_rowMat); 
   f = zeros([m numOutputCols numOutputCols nI]);
   for (i = 1 : m)
      for (jO = 1 : numOutputCols)
         for (jI = 1 : nI)          
            f(i, jO, jO, jI) = input_rowMat(i, jI);
         endfor
      endfor       
   endfor

end