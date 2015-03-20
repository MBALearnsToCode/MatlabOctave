function f = convertArrsToColVec(Arrs_list)

   f = [];
   for (i = 1 : length(Arrs_list))
      f = [f; Arrs_list{i}(:)];   
   endfor

end