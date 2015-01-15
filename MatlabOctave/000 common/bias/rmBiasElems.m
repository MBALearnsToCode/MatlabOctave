function f = rmBiasElems...
   (Mat, nums = [1], firstCol_orRow = 'row')
   
   f = Mat;
   
   switch (firstCol_orRow)
   
      case ('row')
         f = f((nums(1) + 1) : end, :);
         if (length(nums) > 1)
            f = f(:, (nums(2) + 1) : end);
         endif
         
      case ('col')
         f = f(:, (nums(1) + 1) : end);
         if (length(nums) > 1)
            f = f((nums(2) + 1) : end, :);        
         endif

   endswitch

endfunction