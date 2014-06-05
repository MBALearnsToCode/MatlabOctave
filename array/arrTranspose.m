function f = arrTranspose(Arr)

   numDims = arrNumDims(Arr);
   if (numDims <= 1)   
      f = Arr';   
   else      
      f = permute(Arr, fliplr(1 : numDims));   
   endif

end