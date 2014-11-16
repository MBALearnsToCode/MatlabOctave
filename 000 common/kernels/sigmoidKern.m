function f = sigmoidKern(Arr1, Arr2, ...
   timesConst = 1, plusConst = 0)

   f = tanh(timesConst * linearKern(Arr1, Arr2) + plusConst);

end