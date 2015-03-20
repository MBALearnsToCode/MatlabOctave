function f = tanhFunc_rowMat(rowMat, ...
   returnDeriv = true, derivForm = 'eff')

   f.val = tanh(rowMat);
   
   if (returnDeriv)
      switch (derivForm)

         case ('eff')
            val = f.val;
            f.deriv = 1 - (val .^ 2);
      
         case ('gen')
            [m n] = size(rowMat);
            f.deriv = zeros([m n n m]);
            for (i = 1 : m)
               for (j = 1 : n)
                  val = f.val(i, j);
                  f.deriv(i, j, j, i) = 1 - (val ^ 2);
               endfor
            endfor

      endswitch      
   endif
   
endfunction