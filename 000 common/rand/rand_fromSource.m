function f = rand_fromSource(ArrDimSizes, randSource_Mat, seed)
   
   numSamples = prod(ArrDimSizes);         
   startElem = mod(round(seed), ...
      round(columns(randSource_Mat) / 10)) + 1; 
   f = arrTranspose(reshape(randSource_Mat...
      (startElem : (startElem + numSamples - 1)), ...
         fliplr(ArrDimSizes)));

endfunction