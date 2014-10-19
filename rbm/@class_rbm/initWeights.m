function m = initWeights(rbm, sigma_or_epsilon = 1e-2, ...
   distrib = 'normal')
   
   m = rbm;
   switch (distrib)
      case ('normal')
         m.weights = sigma_or_epsilon ...
            * randn(m.weightDimSizes);
      case ('uniform')
         m.weights = randUnif(m.weightDimSizes, ...
            sigma_or_epsilon);
   endswitch
   if (m.addBiasHid * m.addBiasVis)
      m.weights(1, 1) = 0;
   endif
   
endfunction