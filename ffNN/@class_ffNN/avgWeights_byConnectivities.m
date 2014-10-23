function m = avgWeights_byConnectivities(ffNN, ...
   connectivitiesOnOff = {1.0})

   m = ffNN;   
   for (l = 1 : m.numTransforms)
      if (l > 1) && (length(connectivitiesOnOff) < l)
         connectivitiesOnOff{l} = connectivitiesOnOff{l - 1};
      endif
      m.weights{l} .*= connectivitiesOnOff{l};   
   endfor
      
endfunction