function f = sampleSoftmax(rowMat)
   
   m = rows(rowMat);
   n = columns(rowMat);
   
   sampleUnif = rand([m 1]);
   
   f = zeros([m n]);
   rowMat_cumSum_acrossCols = rowMat(:, 1);
   f(:, 1) = sample_cumSum_acrossCols = sampleCol = ...
      rowMat_cumSum_acrossCols >= sampleUnif;
   
   for (j = 2 : n)
      rowMat_cumSum_acrossCols += rowMat(:, j);
      f(:, j) = sampleCol = (1 - sample_cumSum_acrossCols) ...
         .* (rowMat_cumSum_acrossCols >= sampleUnif);
      if (j < n)
         sample_cumSum_acrossCols += sampleCol;
      endif
   endfor   
   
endfunction