function f = convertBinClassIndcs(classIndcs_Arr, ...
   fromClassIndcs_vec = 0, toClassIndx = -1)
   
   f = double(classIndcs_Arr);
   for (fromClassIndx = fromClassIndcs_vec)      
      f(f == fromClassIndx) = toClassIndx;      
   endfor

endfunction