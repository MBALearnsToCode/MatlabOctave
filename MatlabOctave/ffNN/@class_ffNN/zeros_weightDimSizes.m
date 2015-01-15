function m = zeros_weightDimSizes(ffNN)
   
   for (l = 1 : ffNN.numTransforms)
      w = ffNN.weights{l};
      m{l} = zeros(size(w));
   endfor
   
endfunction