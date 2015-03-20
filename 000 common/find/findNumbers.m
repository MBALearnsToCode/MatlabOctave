function f = findNumbers(numbersToFind_Arr, Arr, ...
   precisionTolerance = 1e-12)

   for (i = 1 : numel(numbersToFind_Arr))
      f(i) = findNumber(numbersToFind_Arr(i), Arr, ...
         precisionTolerance);
   endfor
   
   f = reshape(f, size(numbersToFind_Arr));
   
end