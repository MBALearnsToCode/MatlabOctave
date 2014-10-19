function f = sampleBern(probties_Arr)

   f = binornd(1, probties_Arr, size(probties_Arr));
       
endfunction