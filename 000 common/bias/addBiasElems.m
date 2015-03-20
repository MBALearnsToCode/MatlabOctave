function f = addBiasElems...
   (Mat, num = 1, col_or_row = 'col')

   switch (col_or_row)

      case ('col')
         f = [ones([rows(Mat) num]) Mat];

      case ('row')
         f = [ones([num columns(Mat)]); Mat];

   endswitch

endfunction