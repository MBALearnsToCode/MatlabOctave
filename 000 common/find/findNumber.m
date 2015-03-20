function f = findNumber(numberToFind, Arr, ...
   precisionTolerance = 1e-12)

   f = i = 0;
   
   while (~f) && (i < numel(Arr))
      i++;
      if equalTest(Arr(i), numberToFind, precisionTolerance)
         f = i;
      endif
   endwhile

end