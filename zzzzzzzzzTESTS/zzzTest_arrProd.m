function zzzTest_arrProd(numRuns = 1)

   successes = 0; failures = 0;

   for (run = 1 : numRuns)

      fprintf('\rTest #%i', run);

      m = unidrnd(6); n = unidrnd(6); p = unidrnd(6);

      Mat1 = randUnif([m n], 10);
  
      Mat2 = randUnif([n p], 10);

      MatProd = Mat1 * Mat2;

      ArrProd = arrProd(Mat1, Mat2, ...
         min([1 arrNumDims(Mat1) arrNumDims(Mat2)]));

      [eqTest relD] = equalTest(ArrProd, MatProd, 1e-12);

      if (eqTest)

         successes++;
      
      else
         
         failures++;
         fail(failures).Mat1 = Mat1;
         fail(failures).Mat2 = Mat2;
         fail(failures).relD = relD;
      
      endif

   endfor

   fprintf('\n%i Successes / %i Tests\n', successes, numRuns);
   
   for i = 1:failures
       fail(i).Mat1
       fail(i).Mat2
   endfor

end