function f = regulL2_Mat(biasWeight_Mat, exceptBias = true)

   f.val = distAbs...
      (rmBiasElems(biasWeight_Mat, exceptBias), 0, ...
      'EuclidSq') / 2;
   f.grad = zeroBiasElems(biasWeight_Mat, exceptBias);      

end