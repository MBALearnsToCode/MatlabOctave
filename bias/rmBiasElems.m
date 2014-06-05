function f = rmBiasElems...
   (Mat, num = 1, col_or_row = 'row')

   switch (col_or_row)

      case ('col')
         f = Mat(:, (num + 1) : end);

      case ('row')
         f = Mat((num + 1) : end, :);

   endswitch

end