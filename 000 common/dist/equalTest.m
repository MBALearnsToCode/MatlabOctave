function [eqTest relD avgAbsD maxAbsD] = equalTest...
   (Arr1, Arr2 = 0, thresholdPrecision = 1e-12, ...
   rel_or_abs = 'rel', distType = 'Euclid')

   relD = distRel(Arr1, Arr2, 1e-12, distType);
   [distM avgAbsD maxAbsD] = ...
       distAbs(Arr1, Arr2, 'Manhattan');

   switch (rel_or_abs)

      case ('rel')
         eqTest = relD < thresholdPrecision;

      case ('abs') 
         eqTest = avgAbsD < thresholdPrecision;
   
   endswitch

end