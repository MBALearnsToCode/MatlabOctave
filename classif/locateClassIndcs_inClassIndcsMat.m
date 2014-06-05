function f = locateClassIndcs_inClassIndcsMat...
   (classIndcs_Mat, numClasses = 0, ...
   expandBy = 1, expandAlong_row_or_col = 'row')

   classIndcs_no0_Mat = ...
      convertBinClass0ToClass2(classIndcs_Mat);   
   nC = max(numClasses, max(classIndcs_no0_Mat(:)));
   for (k = 1 : nC)
      f{k} = [];
   endfor
   [m n] = size(classIndcs_no0_Mat);
   
   switch (expandAlong_row_or_col)
   
      case ('row')
         for (i = 1 : m)
            for (j = 1 : n)
               f{classIndcs_no0_Mat(i, j)} = ...
                  [f{classIndcs_no0_Mat(i, j)}; ...
                  [i ((j - 1) * expandBy + 1)]];
            endfor
         endfor
      
      case ('col')
         for (i = 1 : m)
            for (j = 1 : n)
               f{classIndcs_no0_Mat(i, j)} = ...
                  [f{classIndcs_no0_Mat(i, j)}; ...
                  [((i - 1) * expandBy + 1) j]];
            endfor
         endfor
         
   endswitch
   
end