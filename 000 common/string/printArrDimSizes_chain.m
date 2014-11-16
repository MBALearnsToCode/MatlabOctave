function f = printArrDimSizes_chain(Arrs_list)

   f = cellfun(@printArrDimSizes, Arrs_list, ...
      'UniformOutput', false);

end