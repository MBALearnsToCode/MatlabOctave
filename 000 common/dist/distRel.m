function f = distRel(Arr1, Arr2, zero = 1e-12, ...
   distType = 'Euclid')

   dist1 = distAbs(Arr1, 0, distType);
   dist2 = distAbs(Arr2, 0, distType);
   if consider0(dist1, zero) && consider0(dist2, zero)
      f = 0;
   else
      f = distAbs(Arr1, Arr2, distType) / (dist1 + dist2);      
   endif

end