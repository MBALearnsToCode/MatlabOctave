function f = arrSumAcrossDims(Arr, sumDims_vec)

   f = Arr;
   for (sumDim = sumDims_vec)
      f = sum(f, sumDim);
   endfor

end