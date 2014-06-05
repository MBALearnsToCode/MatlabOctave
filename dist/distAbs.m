function [dist avgAbsDiff maxAbsDiff] = ...
   distAbs(Arr1, Arr2 = 0, distType = 'Euclid')

   absDiffs_vec = abs(Arr1 - Arr2)(:);

   if ~isempty(absDiffs_vec)
   
      switch (distType)

         case ('Euclid')
            dist = sqrt(sum(absDiffs_vec .* absDiffs_vec));

         case ('EuclidSq')
            dist = sum(absDiffs_vec .* absDiffs_vec);
 
         case ('Manhattan')
            dist = sum(absDiffs_vec);

      endswitch
 
      avgAbsDiff = mean(absDiffs_vec);
      maxAbsDiff = max(absDiffs_vec);
   
   else
 
      maxAbsDiff = avgAbsDiff = dist = 0;

   endif

end