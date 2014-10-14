function f = arrPerm(Arr, perm_vec)

   if (length(perm_vec) <= 1)
      f = Arr;
   else
      f = permute(Arr, perm_vec);
   endif

end