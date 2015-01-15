function f = zeroBiasElems...
   (Mat, nums = [1], firstCol_orRow = 'row')

   f = Mat;
   
   switch (firstCol_orRow)
   
      case ('row')
         n1 = nums(1);
         if (n1 > 0)
            f(1 : n1, :) = 0;
         endif
         if (length(nums) > 1)
            n2 = nums(2);
            if (n2 > 0)
               f(:, 1 : n2) = 0;
            endif
         endif
         
      case ('col')
         n1 = nums(1);
         if (n1 > 0)
            f(:, 1 : n1) = 0;
         endif
         if (length(nums) > 1)
            n2 = nums(2);
            if (n2 > 0)
               f(1 : n2, :) = 0;
            endif
         endif
         
   endswitch   
      
endfunction