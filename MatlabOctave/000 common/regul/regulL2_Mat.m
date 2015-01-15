function f = regulL2_Mat(biasWeight_Mat, ...
   exceptBiases = [true], returnGrad = false)

   f.val = distAbs...
      (rmBiasElems(biasWeight_Mat, exceptBiases), 0, ...
      'EuclidSq') / 2;
   if (returnGrad)
      f.grad = zeroBiasElems(biasWeight_Mat, exceptBiases);
   endif

endfunction