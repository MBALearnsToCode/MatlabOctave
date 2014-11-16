function f = matFetchElems_by2ColMat(Mat, indcs_2ColMat, ...
   numElemsToFetch = 1, fetchAlong_row_or_col = 'row')

   m = rows(indcs_2ColMat);   
   
   switch (fetchAlong_row_or_col)
  
      case ('row')
         f = zeros([m numElemsToFetch]);
         for (i = 1 : m)
            rowNum = indcs_2ColMat(i, 1);
            colStart = indcs_2ColMat(i, 2);
            colEnd = colStart + numElemsToFetch - 1;
            f(i, :) = Mat(rowNum, colStart : colEnd);  
         endfor
      
      case ('col')
         f = zeros([numElemsToFetch m]);
         for (i = 1 : m)
            colNum = indcs_2ColMat(i, 2);
            rowStart = indcs_2ColMat(i, 1);
            rowEnd = rowStart + numElemsToFetch - 1;   
            f(:, i) = Mat(rowStart : rowEnd, colNum);
         endfor

   endswitch

end