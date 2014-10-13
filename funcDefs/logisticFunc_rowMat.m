function f = logisticFunc_rowMat(rowMat, ...
   returnDeriv = true, derivForm = 'eff')

   f.val = 1 ./ (1 + exp(-rowMat));
   
   if (returnDeriv)   
      switch (derivForm)

         case ('eff')
            val = f.val;
            f.deriv = val .* (1 - val);
      
         case ('gen')
            [m n] = size(rowMat);
            f.deriv = zeros([m n n m]);
            for (i = 1 : m)
               for (j = 1 : n)
                  val = f.val(i, j);
                  f.deriv(i, j, j, i) = val * (1 - val);
               endfor
            endfor

      endswitch      
   endif
   
endfunction