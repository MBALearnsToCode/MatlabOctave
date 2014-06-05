function f = linearFunc_Mat(Mat, ...
   returnDeriv = true, derivForm = 'eff')

   f.val = Mat;
 
   if (returnDeriv)

      switch (derivForm)

         case ('gen')
            [m n] = size(Mat);
            f.deriv = zeros([m n n m]);
            for (i = 1 : m)
               for (j = 1 : n)
                  f.deriv(i, j, j, i) = 1;
               endfor
            endfor

         case ('eff')
            f.deriv = 1;

      endswitch
 
   endif

end