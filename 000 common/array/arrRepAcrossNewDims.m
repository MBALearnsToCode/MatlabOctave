function f = ...
   arrRepAcrossNewDims(Arr, existingNumDims, repTimes_vec)

   f = Arr;
   newDim = max(existingNumDims, arrNumDims(Arr));

   for (repTimes = repTimes_vec)
      repArr = f;
      newDim++;
      for (repTime = 1 : (repTimes - 1))
          f = cat(newDim, f, repArr);
      endfor
   endfor

end