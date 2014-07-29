function f = regulL1_Mat(biasWeight_Mat, exceptBias = true)

   f.val = distAbs...
      (rmBiasElems(biasWeight_Mat, exceptBias), 0, ...
      'Manhattan');
   f.grad = sign(zeroBiasElems(biasWeight_Mat, exceptBias));
   
end