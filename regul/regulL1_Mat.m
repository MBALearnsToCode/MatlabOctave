function f = regulL1_Mat(biasWeight_Mat, exceptBias = true, ...
   returnGrad = false)

   f.val = distAbs...
      (rmBiasElems(biasWeight_Mat, exceptBias), 0, ...
      'Manhattan');
   if (returnGrad)
      f.grad = sign(zeroBiasElems(biasWeight_Mat, exceptBias));
   endif
   
end