function m = initWeights(ffNN, sigma_or_epsilon = 1e-2, ...
   distrib = 'normal')
   
   m = ffNN;

   switch (distrib)

      case ('normal')
         for (l = 1 : m.numTransforms)
            m.weights{l} = sigma_or_epsilon ...
               * randn(m.weightDimSizes{l});
         endfor

      case ('uniform')
         for (l = 1 : m.numTransforms)
            m.weights{l} = randUnif(m.weightDimSizes{l}, ...
               sigma_or_epsilon); 
         endfor
        
   endswitch
   
endfunction