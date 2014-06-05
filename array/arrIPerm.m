function f = arrIPerm(Arr, iPerm_vec)

   if (length(iPerm_vec) <= 1)
      f = Arr;
   else
      f = ipermute(Arr, iPerm_vec);   
   endif

end