function f = softmaxFunc_rowMat(rowMat, ...
   returnDeriv = true, derivForm = 'eff')
  
   [m n] = size(rowMat);

   Mat_subtractRowMax = ...
      bsxfun(@minus, rowMat, max(rowMat, [], 2)); 
   expMat = exp(Mat_subtractRowMax);

   f.val = bsxfun(@rdivide, expMat, sum(expMat, 2));
   
   if (returnDeriv)
   
      switch (derivForm)
         
         case ('gen')
            f.deriv = zeros([m n n m]);
            for (i = 1 : m)
               for (j = 1 : n)
                  for (k = j : n)
                     f.deriv(i, j, k, i) = ...
                        f.deriv(i, k, j, i) = ...
                        softmaxFunc_colVec...
                        (rowMat(i,:)').deriv(j, k);  
                  endfor
               endfor
            endfor
   
         case ('eff')
            f.deriv = zeros([m n n]);
            for (i = 1 : m)         
               val = f.val(i, :);
               f.deriv(i, :, :) = permute...
                  (diag(val) - val' * val, [3 1 2]);
            endfor

      endswitch
      
   endif

end