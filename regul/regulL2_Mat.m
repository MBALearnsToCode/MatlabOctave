function f = regulL2_Mat(biasWeight_Mat, exceptBias = true, ...
   returnGrad = false)

   f.val = distAbs...
      (rmBiasElems(biasWeight_Mat, exceptBias), 0, ...
      'EuclidSq') / 2;
   if (returnGrad)
      f.grad = zeroBiasElems(biasWeight_Mat, exceptBias);
   endif

end