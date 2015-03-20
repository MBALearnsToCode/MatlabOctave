function f = Reshape(Arr, reshape_vec)
   
   if (length(reshape_vec) == 1)
      f = reshape(Arr, [reshape_vec 1]);
   else
      f = reshape(Arr, reshape_vec);
   endif    

end