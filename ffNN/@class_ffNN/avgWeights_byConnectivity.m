function m = avgWeights_byConnectivity(ffNN, ...
   connectivity_byLayer = {1.0})

   m = ffNN;   
   for (l = 1 : m.numTransforms)
      if (l > 1) && isempty(connectivity_byLayer{l})
         connectivity_byLayer{l} = connectivity_byLayer{l - 1};
      endif
      m.weights{l} .*= connectivity_byLayer{l};   
   endfor
      
endfunction