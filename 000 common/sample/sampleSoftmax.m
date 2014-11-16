function f = sampleSoftmax(probs_rowMat, ...
   useRandSource = false, randSource_Mat = [])
   
   m = rows(rowMat);
   n = columns(rowMat);
   
   if (useRandSource)
      seed = sum(probs_rowMat(:));
      sampleUnif = rand_fromSource([m 1], ...
         randSource_Mat, seed);
   else
      sampleUnif = rand([m 1]);
   endif
   
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