function f = printArrs_chain(Arrs_list)

   f = cellfun(@mat2str, Arrs_list, ...
      'UniformOutput', false);

end