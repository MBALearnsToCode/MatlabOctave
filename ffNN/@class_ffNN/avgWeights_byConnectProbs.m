function m = avgWeights_byConnectProbs(ffNN, ...
   connectProbs = [1.0])

   m = ffNN;   
   for (l = 1 : m.numTransforms)
      if (l > 1) && (length(connectProbs) < l)
         connectProbs(l) = connectProbs(l - 1);
      endif
      m.weights{l} *= connectProbs(l);
   endfor
      
endfunction