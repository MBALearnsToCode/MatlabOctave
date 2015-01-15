function f = convertColVecToArrs(colVec, arrDimSizes_list)

   v = colVec;
   for (i = 1 : length(arrDimSizes_list))
      numElems = ~isempty(arrDimSizes_list{i}) ...
         * prod(arrDimSizes_list{i});
      f{i} = reshape(v(1 : numElems), ...
         arrDimSizes_list{i});
      v = v((numElems + 1) : end);   
   endfor

end