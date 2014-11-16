% ARRIPERM is a variation of the built-in IPERMUTE function
% that allows the inverse-permutation vector to have length
% < 2, in which case the function's output is just the same
% as its input.



function f = arrIPerm(Arr, iPerm_vec)

   if (length(iPerm_vec) <= 1)
      f = Arr;
   else
      f = ipermute(Arr, iPerm_vec);   
   endif

end