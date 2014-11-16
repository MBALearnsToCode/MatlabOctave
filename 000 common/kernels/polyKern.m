function f = polyKern(Arr1, Arr2, ...
   timesConst = 1, plusConst = 1, toDegree = 2)

   f = (timesConst * linearKern(Arr1, Arr2) ...
      + plusConst) ^ toDegree;

end