function [optimInput optimOutput] = quadraticOptim...
   (coeff2 = 1, coeff1 = 0, coeff0 = 0, ...
   inputBound = [-Inf Inf])

   inputLowerBound = inputBound(1);
   inputUpperBound = inputBound(2);
   
   if (inputLowerBound > inputUpperBound)

      optimInput = optimOutput = NA;

   elseif (inputLowerBound == inputUpperBound)
   
      optimInput = inputLowerBound;
      optimOutput = quadraticFunc(optimInput, ...
            coeff2, coeff1, coeff0);
   
   else
   
      optimInput_unbounded = - coeff1 / (2 * coeff2);

      if (optimInput_unbounded >= inputLowerBound) && ...
         (optimInput_unbounded <= inputUpperBound)
  
         optimInput = optimInput_unbounded;
         optimOutput = ...
            - (coeff1 ^ 2) / (4 * coeff2) + coeff0;

      else

         distInputLowerBound_fromUnboundedOptim = ...
            abs(inputLowerBound - optimInput_unbounded);
         distInputUpperBound_fromUnboundedOptim = ...
            abs(inputUpperBound - optimInput_unbounded);
         if (distInputLowerBound_fromUnboundedOptim ...
            < distInputUpperBound_fromUnboundedOptim)
            optimInput = inputLowerBound;
         else
            optimInput = inputUpperBound;
         endif
         optimOutput = quadraticFunc(optimInput, ...
            coeff2, coeff1, coeff0);
   
      endif
      
   endif
   
end