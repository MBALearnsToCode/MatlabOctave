function f = arrSetHighestDim(Arr, targetHighestDim)

   existingNumDims = arrNumDims(Arr);   
   if (targetHighestDim > existingNumDims)
      perm_vec = 1 : targetHighestDim;
      perm_vec(existingNumDims) = targetHighestDim;
      perm_vec(targetHighestDim) = existingNumDims;
      f = arrPerm(Arr, perm_vec);
   else
      f = Arr;
   endif

end