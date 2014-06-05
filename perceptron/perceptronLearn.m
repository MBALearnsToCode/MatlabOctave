function [W, numIters] = perceptronLearn(X, Y, maxNumIters)
   
   numIters = 0;

   W = randUnif([columns(X) columns(Y)]);
   
   %fprintf('Iterations: ');
   
   while (numIters <= maxNumIters)

      %fprintf('%i ', numIters);

      Err = binThreshFunc(X * W) - Y;

      if (Err == 0)

         break;

      else

         numIters++;

         W -= X' * Err;

      endif
   
   endwhile

   %fprintf('\nIterations finished! .|.');

end