function f = zeroBiasElems...
   (Mat, num = 1, col_or_row = 'row')

   f = Mat;
   
   if (num > 0)
      switch (col_or_row)

         case ('col')
            f(:, 1 : num) = 0;

         case ('row')
            f(1 : num, :) = 0;
            
      endswitch   
   endif
   
end