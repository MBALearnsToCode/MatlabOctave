function f = arrProd_chain(Arrs_list, numsElimDims_vec)

   f = Arrs_list{1};   
   for (i = 2 : length(Arrs_list))
      f = arrProd(f, Arrs_list{i}, ...
         numsElimDims_vec(i - 1));
   endfor

end