function f = ffNN_initParams(ffNN, ...
   sigma_or_epsilon = 1e-2, distrib = 'normal', ...
   randInit = true)
   
   f = ffNN;

   switch (distrib)

      case ('normal')
         for (l = 2 : f.numLayers)
            f.params{l} = randInit * sigma_or_epsilon ...
               * randn(f.paramDimSizes{l});
         endfor

      case ('uniform')
         for (l = 2 : f.numLayers)
            f.params{l} = randInit ...
               * randUnif(f.paramDimSizes{l}, ...
               sigma_or_epsilon); 
         endfor
        
   endswitch
   
end