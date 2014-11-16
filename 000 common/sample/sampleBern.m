function f = sampleBern(probs_Arr, ...
   useRandSource = false, randSource_Mat = [])

   if (useRandSource)
   
      dimSizes = size(probs_Arr);
      seed = sum(probs_Arr(:));
      extractedRand = rand_fromSource(dimSizes, ...
         randSource_Mat, seed);
      f = probs_Arr > extractedRand;
      
   else
   
      f = binornd(1, probs_Arr, size(probs_Arr));
      
   endif
       
endfunction