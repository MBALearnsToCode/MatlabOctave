function [eqTest maxAbsDiff] = ...
   equalTest_chain(Arrs_list, thresholdPrecision = 1e-12, ...
   rel_or_abs = 'rel', distType = 'Euclid')  

   eqTest = true; maxAbsDiff = 0;   
   for (i = 1 : (length(Arrs_list) - 1))
      [eqTest_bw2 dummy1 dummy2 maxAbsDiff_bw2] = ...
         equalTest(Arrs_list{i}, Arrs_list{i + 1}, ...
         thresholdPrecision, rel_or_abs, distType);
      eqTest = eqTest && eqTest_bw2;      
      maxAbsDiff = max(maxAbsDiff, maxAbsDiff_bw2);
   endfor

end