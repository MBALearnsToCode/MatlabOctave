function f = randUnif(arrDimSizes_vec, epsilon = 1)
   
   if (epsilon == 0)      
      f = zeros(arrDimSizes_vec);
   else 
      f = unifrnd(-epsilon, epsilon, arrDimSizes_vec);
   endif
     
end